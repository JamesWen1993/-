//
//  ActivityDetailVc.m
//  人人社交
//
//  Created by huiwenjiaoyu on 15/10/28.
//  Copyright © 2015年 huiwen. All rights reserved.
//

#import "ActivityDetailVc.h"
#import "SendViewController.h"
#import "AVUser+Avatar.h"
#import "UIImageView+AFNetworking.h"
@interface ActivityDetailVc ()<UITableViewDelegate, UITableViewDataSource>{
    
    UITableView *_tableView;
    UIView *_headerView;
    SendViewController *_sendVC;
    
    NSString *_activityTime;
    NSString *_signUpTime;
    NSString *_activityLocation;
    
    BOOL _isSignUp;//是否已经报名
}

@end

@implementation ActivityDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self _createTableView];
    [self _createView];
    [self _createNavigationItem];
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    
    //初始化为 未报名
    _isSignUp = NO;
}

- (void)_createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //头视图
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 78)];
    _tableView.tableHeaderView = _headerView;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
}

- (void)_createNavigationItem{
    
    //创建发布按钮
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signupButton.frame = CGRectMake(0, 0, 40, 30);
    
    // 标题
    [signupButton setTitle:@"报名" forState:UIControlStateNormal];
    [signupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 属性
    signupButton.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:205 / 255.0 blue:0 alpha:1];
    signupButton.layer.cornerRadius = 10;
    signupButton.layer.borderColor = [UIColor colorWithRed:89 / 255.0 green:89 / 255.0 blue:89 / 255.0 alpha:1].CGColor;
    signupButton.layer.borderWidth = 2;
    signupButton.titleLabel.font = [UIFont systemFontOfSize:14];
    // 添加按钮
    [signupButton addTarget:self
                     action:@selector(signUpAction)
           forControlEvents:UIControlEventTouchUpInside];
    // 添加到导航栏
    UIBarButtonItem *signupBarItem = [[UIBarButtonItem alloc] initWithCustomView:signupButton];
    self.navigationItem.rightBarButtonItem = signupBarItem;
    
}

- (void)_createView{
    
    //活动主题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 10, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.text = _model.activity_Title;
    [_headerView addSubview:_titleLabel];
    
    
    
    //头像
    _userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 30, 30)];
    _userImage.backgroundColor = [UIColor grayColor];
    _userImage.layer.cornerRadius = 15;
    [_headerView addSubview:_userImage];
    
    //昵称
    _nickName = [[UILabel alloc] initWithFrame:CGRectMake(45, 48, 200, 25)];
    _nickName.font = [UIFont systemFontOfSize:15];
    _nickName.textColor = [UIColor blueColor];
    _nickName.text = @"wen";
    [_headerView addSubview:_nickName];
    
    
    AVUser *user = [AVUser currentUser];
    _nickName.text = user.username;
    [_userImage setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"Upload_avata@3x"]];
    
    //活动详情
    _activityDetail = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , 1000)];
    
    _activityDetail.editable = NO;
    _activityDetail.font = [UIFont systemFontOfSize:17];
    _activityDetail.text = _model.activity_Detail;

}

#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:

                
            cell.textLabel.text = [NSString stringWithFormat:@"活动时间：%@",_model.activity_Time];
            
            break;
            
        
        case 1:

                
            cell.textLabel.text = [NSString stringWithFormat:@"报名截止：%@",_model.activity_SignUpFinishTime];
                

            
            break;
            
        case 2:

            cell.textLabel.text = [NSString stringWithFormat:@"活动地点：%@ %@",_model.activity_Location, _model.activity_LocationDetail];

            
            break;
        
        case 3:
//            int peopleNum = [_model.activity_maxPeopleNum intValue];
            NSLog(@"%li",[_model.activity_maxPeopleNum integerValue]);
            NSInteger peoplrNum = [_model.activity_maxPeopleNum integerValue];
            if (peoplrNum == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"人数限定：无限制(已报名%@人)", _model.activity_peopleNum];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"人数限定：%@(已报名%@人)", _model.activity_maxPeopleNum, _model.activity_peopleNum];
                
            }
            
            
            
            break;
            
        case 4:
            //活动详情
            [cell.contentView addSubview:_activityDetail];
            
            break;

    }

    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 4) {
        
        //拿到textview 对象
        NSString *string = _activityDetail.text;
        
        //计算字符串的长度
        CGSize maxSize = CGSizeMake(kScreenWidth, CGFLOAT_MAX);
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17]};
        
        CGRect rect = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        return rect.size.height + 10;
    
    }
    return 25;
}
- (void)signUpAction{

    
    //activity_peopleNum 报名人数 技术加一
    AVObject *post = [AVObject objectWithoutDataWithClassName:@"Post" objectId:_model.objectId];
    [post incrementKey:@"activity_peopleNum"];
    
    [post saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];
    return;
    
}

-(void)viewWillAppear:(BOOL)animated{
    _sendVC = [[SendViewController alloc] init];
    [_tableView reloadData];
    
}

//返回显示tabBar
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
