//
//  LoginViewController.m
//  人人社交
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CDUserFactory.h"
#import "HomeViewController.h"
#import "RegsierViewController.h"
#import "AVUser+Avatar.h"



@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passWordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _loginTextField.placeholder = @"用户名/手机号码";
    _passWordTextField.placeholder = @"请输入密码";
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0  blue:230/255.0  alpha:1];
}

- (IBAction)login:(UIButton *)sender {
    [_loginTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];
    [self showHUD:@"正在登录中..."];
    [AVUser logInWithUsernameInBackground:_loginTextField.text
                                 password:_passWordTextField.text
                                    block:^(AVUser *user, NSError *error){
                                        if (error) {
                                            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            [view show];
                                        } else {
                                            [self pushToMainViewController];
                                        }
                                    }];

    
}


- (void)pushToMainViewController {
    
    AVUser* currentUser = [AVUser currentUser];

    [[CDChatManager manager] openWithClientId:currentUser.username useravatarUrl:currentUser.avatarUrl callback:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            // 出错了，可能是网络问题无法连接 LeanCloud 云端，请检查网络之后重试。
            // 此时聊天服务不可用。
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"聊天不可用！" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [view show];
        } else {
            // 成功登录，可以进入聊天主界面了。
            [self hideHUD];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _loginTextField.text = @"";
    _passWordTextField.text = @"";
}
- (IBAction)regsierButton:(UIButton *)sender {
    
    [self presentViewController:[RegsierViewController alloc] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (self.view == view) {
        [self dismissKeyboard];
    }
}

- (void)dismissKeyboard
{
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews)
    {
        if ([objInput isKindOfClass:[UITextField class]])
        {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder])
            {
                [theTextField resignFirstResponder];
            }
        }
    }
}

@end
