//
//  SendViewController.m
//  人人社交
//
//  Created by huiwenjiaoyu on 15/10/26.
//  Copyright © 2015年 huiwen. All rights reserved.
//

#import "SendViewController.h"
#import "JKCityPickerView.h"
#import "DataPickerView.h"
#import "UIViewExt.h"
#import "AVCloud.h"
#import <AVOSCloud.h>
#import "MapViewController.h"
#import "NearbyViewController.h"
#import "ActivityModel.h"
#import "AVUser+Avatar.h"

@interface SendViewController (){
    
    UITableView *_tableView;
    BOOL _isNeedMoveUp; //视图需要上移
    CLLocationManager *_locationManager;
    NearbyViewController *_nearbyVC;
    BOOL _avatarUpdating;
    
    UIImageView *_postImage;
    UIButton *_addPostImageBtn;
    AVFile *_imageFile;
}

@end

@implementation SendViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布活动";
    [self _createView];
    self.view.userInteractionEnabled = YES;
    
    //初始化需要上移为NO
    _isNeedMoveUp = NO;
    
    //当点击键盘以外的地方收起键盘
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    
    //全局mapView
//    _mapView = [[MapViewController alloc] init];
    _nearbyVC = [[NearbyViewController alloc] init];
}



#pragma mark - 创建视图
- (void)_createView{
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:_tableView];
    
    //创建发布按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(0, 0, 40, 30);
    
    //标题
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //属性
    sendButton.backgroundColor = [UIColor colorWithRed:242/255.0 green:205/255.0 blue:0 alpha:1];
    sendButton.layer.cornerRadius = 10;
    sendButton.layer.borderColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1].CGColor;
    sendButton.layer.borderWidth = 2;
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //添加按钮
    [sendButton addTarget:self
                   action:@selector(sendAction)
         forControlEvents:UIControlEventTouchUpInside];
    //添加到导航栏
    UIBarButtonItem *sendBarItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = sendBarItem;
    
    
    //添加海报
    _addPostImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addPostImageBtn.frame = CGRectMake(10, 20, 80, 30);
    _addPostImageBtn.layer.cornerRadius = 10;
    _addPostImageBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _addPostImageBtn.layer.borderWidth = 1;
    
    [_addPostImageBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    [_addPostImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _addPostImageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_addPostImageBtn addTarget:self
                         action:@selector(_postImageButtonAction)
               forControlEvents:UIControlEventTouchUpInside];
    
    //海报
    _postImage = [[UIImageView alloc] initWithFrame:CGRectMake(120, 5, 60, 60)];
    
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 3;
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.section) {
            case 0:
                
                //活动主题
                cell.textLabel.text = @"活动主题：";
                _titleText = [[UITextField alloc] initWithFrame:CGRectMake(97, 8, kScreenWidth-100, 25)];
                [cell.contentView addSubview:_titleText];
                break;
                
            case 1:
                if (indexPath.row == 0) {
                    
                    // 活动时间
                    cell.textLabel.text = @"活动时间：";
                    _timeText = [[UITextField alloc] initWithFrame:CGRectMake(97, 8, kScreenWidth-100, 25)];
                    [cell.contentView addSubview:_timeText];

                    //时间选择 滚轮视图
                    [self _createDataPickerView:_timeText];
                    
                }else {
                    
                    // 报名截止
                    cell.textLabel.text = @"报名截止：";
                    _signupFinishText = [[UITextField alloc] initWithFrame:CGRectMake(97, 8, kScreenWidth-100, 25)];
                    [cell.contentView addSubview:_signupFinishText];
                    
                    //时间选择 滚轮视图
                    [self _createDataPickerView:_signupFinishText];
                }
                break;
                
            case 2:
                if (indexPath.row == 0) {
                    
                    //活动地点
                    cell.textLabel.text = @"活动地点：";
                    _locationText = [[UITextField alloc] initWithFrame:CGRectMake(97, 8, kScreenWidth-100, 25)];
                    [cell.contentView addSubview:_locationText];
                    
                    //城市选择 滚轮视图
                    [self _createCityPickerView:_locationText];
                    
                }else if(indexPath.row == 1) {
                    
                    // 详细位置
                    cell.textLabel.text = @"详细位置：";
                    _locationDetailText = [[UITextField alloc] initWithFrame:CGRectMake(97, 8, kScreenWidth-100, 25)];
                    [cell.contentView addSubview:_locationDetailText];
                    _locationDetailText.delegate = self;

                    
                }else{
                    
                    // 选择的经纬度

                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    
                    if (_mapView.lonStr != nil && _mapView.latStr != nil) {
                        cell.hidden = NO;
                        
                        [_mapView setBlock:^(NSString *lonStr, NSString *latStr){
                            
                            cell.textLabel.text = [NSString stringWithFormat:@"经度:%@,纬度:%@",lonStr, latStr];
                        }];
                    }
                    cell.hidden = YES;
                    
                }
                break;
                
            case 3:
                
                // 活动费用
                if (indexPath.row == 0) {
                    
                    cell.textLabel.text = @"活动费用：";
                    _moneyText = [[UITextField alloc] initWithFrame:CGRectMake(97, 8, kScreenWidth-100, 25)];
                    [cell.contentView addSubview:_moneyText];
                    
                    _moneyText.tag = 100;
                    _moneyText.delegate = self;
                    
                }else if(indexPath.row == 1){
                    
                    //限定人数
                    cell.textLabel.text = @"限定人数：";
                    _maxPeopleNum = [[UITextField alloc] initWithFrame:CGRectMake(97, 8, kScreenWidth-100, 25)];
                    _maxPeopleNum.delegate = self;
                    _maxPeopleNum.tag = 101;
                    [cell.contentView addSubview:_maxPeopleNum];
                    
                }else{
                    
                    //图片选择
                    [cell.contentView addSubview:_addPostImageBtn];
                    [cell.contentView addSubview:_postImage];

                }
                
                break;
                
            default: //活动详情
                _activityDetailText = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
                _activityDetailText.editable = YES;
                _activityDetailText.delegate = self;
                _activityDetailText.font = [UIFont systemFontOfSize:15];
                //_activityDetailText.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                [cell.contentView addSubview:_activityDetailText];
                break;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return 17;
    }else if (section == 3) {
        return 1;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        return 200;
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        return 18;
    }
    if (indexPath.section == 3 && indexPath.row == 2) {
        return 70;
    }
    return 42;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return @"活动详情";
    }
    return nil;
}



-(void)_postImageButtonAction{
    
    
    [self.view endEditing:YES];
    //收起键盘 视图位置还原
    self.view.bottom = kScreenHeight - 49;
    
    //图片选择
    UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Images",nil];
    [actionSheet showInView:self.view];
    
}


#pragma mark - Add Picture
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addCarema];
    }else if (buttonIndex == 1){
        [self openPicLibrary];
    }
}

-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        _postImage.image = editImage;
        
        NSData *imageData = UIImagePNGRepresentation(editImage);
        _imageFile = [AVFile fileWithName:@"postImage.png" data:imageData];
        [_imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                NSLog(@"%@",error);
            }
        } progressBlock:^(NSInteger percentDone) {
            NSLog(@"--------------------------%li",percentDone);
        }];
        
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 城市选择滚轮 和 时间滚轮视图
// 创建城市选择滚轮视图
- (void)_createCityPickerView:(UITextField *)text{
    JKCityPickerView *cityPickerView = [[JKCityPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight-260, kScreenWidth, 260)];
    text.inputView = cityPickerView;
    
    //解析JSON获取数据
    NSArray *dataList = [[self loadJSON:@"cityDataList"] objectForKey:@"dataList"];
    [cityPickerView setDataList:dataList];
    
    //Block回调数据
    [cityPickerView setOnChangeBlock:^(NSString *province, NSString *city,NSDictionary *cityItem) {
        text.text = [province stringByAppendingString:city];
    }];
    [cityPickerView setRightActionBlock:^(NSString *province, NSString *city,NSDictionary *cityItem) {
        text.text = [province stringByAppendingString:city];
    }];
}

//解析城市列表JSON
-(NSDictionary*)loadJSON:(NSString*)jsonName{
    NSError *errorString;
    NSError *errorJson;
    
    NSString *JsonPath = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    NSString *jsonString=[NSString stringWithContentsOfFile:JsonPath encoding:NSUTF8StringEncoding error:&errorString];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    return jsonDict;
}

// 创建时间选择滚轮视图
- (void)_createDataPickerView:(UITextField *)text{
    
    DataPickerView *dataPicker = [[DataPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight-260, kScreenWidth, 260)];
    
    //推出视图
    text.inputView = dataPicker;
    
    //Block回调数据传给text
    [dataPicker setRightActionBlock:^(NSString *mouthStr, NSString *dayStr, NSString *hourStr, NSString *minutesStr) {
        text.text = [NSString stringWithFormat:@"%@%@ %@ : %@",mouthStr,dayStr,hourStr,minutesStr];
    }];
}

// 收起键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
    
    //收起键盘 视图位置还原
    self.view.bottom = kScreenHeight - 49;
    _isNeedMoveUp = NO;
}

#pragma mark - _activityDetailText 代理
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _isNeedMoveUp = YES;
    //键盘弹出 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    return YES;
}

#pragma mark - _moneyTextField 代理

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //编辑活动费用时
    if (textField.tag == 100 || textField.tag == 101) {
        
        _isNeedMoveUp = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
    }
    return YES;
}

#pragma mark - 键盘弹出通知
- (void)keyBoardWillShow:(NSNotification *)notification{
    
    if (_isNeedMoveUp == YES) {
        
        //1 取出键盘frame,这个frame 相对于window的
        NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect frame = [bounsValue CGRectValue];
        
        //2 键盘高度
        CGFloat height = frame.size.height;
        
        //3 调整视图的高度
        self.view.bottom = kScreenHeight - height - 49;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//发布按钮方法
- (void)sendAction{
    
    //收起键盘 视图位置还原
    self.view.bottom = kScreenHeight - 49;
    if (_titleText.text.length == 0 || _timeText.text.length == 0 || _signupFinishText.text.length == 0 || _locationText.text.length == 0 || _locationDetailText.text .length == 0 || _moneyText.text.length == 0 || _activityDetailText.text.length == 0 || _activityDetailText.text.length == 0 || _maxPeopleNum.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    //确定发送
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定发布" delegate:self cancelButtonTitle:@"我再想想" otherButtonTitles:@"确认发送", nil];
    [alertView show]; 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) { //确定发送
        AVObject *testObject = [AVObject objectWithClassName:@"Post"];
        [testObject setObject:_titleText.text forKey:@"activity_Title"];
        [testObject setObject:_timeText.text forKey:@"activity_Time"];
        [testObject setObject:_signupFinishText.text forKey:@"activity_SignUpFinishTime"];
        [testObject setObject:_locationText.text forKey:@"activity_Location"];
        [testObject setObject:_locationDetailText.text forKey:@"activity_LocationDetail"];
        [testObject setObject:_moneyText.text forKey:@"activity_Money"];
        [testObject setObject:_activityDetailText.text forKey:@"activity_Detail"];
        [testObject setObject:_maxPeopleNum.text forKey:@"activity_maxPeopleNum"];
        [testObject setObject:[NSNumber numberWithInt:0] forKey:@"activity_peopleNum"];
        [testObject setObject:_imageFile       forKey:@"activity_PosterImage"];
        
        [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                NSLog(@"%@",error);
            }
            else {
                NSLog(@"-------------------------------------send success");
                _titleText.text = @"";
                _timeText.text = @"";
                _signupFinishText.text = @"";
                _locationText.text = @"";
                _locationDetailText.text = @"";
                _moneyText.text = @"";
                _activityDetailText.text  = @"";
                _postImage.image = nil;
            }
        }];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

//返回显示tabBar
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{

    [_tableView reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
