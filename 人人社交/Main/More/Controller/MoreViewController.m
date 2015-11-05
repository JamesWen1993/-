//
//  MoreViewController.m
//  人人社交
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreViewController.h"
#import "AVUser.h"
#import "AVUser+Avatar.h"
#import "UIImageView+AFNetworking.h"
#import "CDUserFactory.h"
#import "LoginViewController.h"
#import "UIView+Blur.h"

@interface MoreViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL _avatarUpdating;
    UITableView *_tableView;
    UIView *_headView;
    UIButton *_logOutButton;
    UIImageView *_userImage;
    UILabel *_userName;
}



@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"更多";
    [self _createView];
    
}

- (void)_createView{
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //用户名
    _userName = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, 120, 200, 30)];
    _userName.textColor = [UIColor orangeColor];
    _userName.font = [UIFont systemFontOfSize:18 weight:10];
    [_userName setTextAlignment:NSTextAlignmentCenter];
    
    //用户头像
    _userImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2, 20, 80, 80)];
    _userImage.layer.masksToBounds = YES;
    _userImage.layer.cornerRadius = 10;
    [_userImage setUserInteractionEnabled:YES];
    [_userImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserAvatar)]];
    
    //创建头视图
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"companybg.jpeg"]];

    [_headView enableBlur:YES];
    [_headView setBlurStyle:UIViewBlurLightStyle];
    [_headView addSubview:_userImage];
    [_headView addSubview:_userName];
    _tableView.tableHeaderView = _headView;
    
    //创建退出按钮
    _logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _logOutButton.frame = CGRectMake((kScreenWidth-90), 0, 180, 40);
    
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.text = @"1";
        
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"个人信息";
                        break;
                    case 1:
                        cell.textLabel.text = @"清除缓存";
                        break;
                    case 2:
                        cell.textLabel.text = @"版本更新";
                        break;
                    case 3:
                        cell.textLabel.text = @"意见反馈";
                        break;

                }
                break;
            case 1:
                cell.textLabel.text = @"退出当前账号";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor whiteColor];
//                UIImage *image = [UIImage imageNamed:@"login"];
                cell.backgroundColor = [UIColor orangeColor];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
        //退出登录
        if (_avatarUpdating) {
            return;
        }
        [AVUser logOut];
        
        [[CDChatManager manager] closeWithCallback:^(BOOL succeeded, NSError *error) {
            [self presentViewController:[LoginViewController alloc] animated:YES completion:nil];
        }];
    }
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AVUser *currentUser = [AVUser currentUser];
    [_userName setText:[NSString stringWithFormat:@"%@",[currentUser username]]];
    NSString *avatarUrl = currentUser.avatarUrl;
    if ([avatarUrl length] > 0) {
        [_userImage setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"Upload_avata@3x"]];
        NSLog(@"----------------------------%@",avatarUrl);
    } else {
        [_userImage setImage:[UIImage imageNamed:@"Upload_avata@3x"]];
    }
    _avatarUpdating = NO;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeUserAvatar {
    
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
        AVUser *currentUser = [AVUser currentUser];
        _avatarUpdating = YES;
        [currentUser updateAvatarWithImage:editImage callback:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed" message:[NSString stringWithFormat:@" detail: %@", [error description]] delegate:nil cancelButtonTitle:@"造了" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                [_userImage setImage:editImage];
            }
            _avatarUpdating = NO;
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
