//
//  RegsierViewController.m
//  人人社交
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "RegsierViewController.h"
#import "AVOSCloud.h"
#import "AVUser+Avatar.h"
@interface RegsierViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImage *_customeImage;
}

@property (strong, nonatomic) IBOutlet UITextField *regsierName;
@property (strong, nonatomic) IBOutlet UITextField *regiserPassWord;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UIButton *regiserButton;

@end

@implementation RegsierViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.cornerRadius = 40;
    _avatar.backgroundColor = [UIColor whiteColor];
    _avatar.image = [UIImage imageNamed:@"Upload_avata@3x"];
    [_avatar setUserInteractionEnabled:YES];
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)]];
    _customeImage = nil;
    _regsierName.placeholder = @"请输入账号:";
    _regiserPassWord.placeholder = @"请输入密码:";
    _email.placeholder = @"请输入邮箱:";
    [_regiserButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
}
- (IBAction)regiser:(UIButton *)sender {
    
    AVUser *user = [AVUser user];
    user.username = _regsierName.text;
    user.email = _email.text;
    user.password = _regiserPassWord.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (_customeImage) {
                AVUser *currentUser = [AVUser currentUser];
                [currentUser updateAvatarWithImage:_customeImage callback:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        NSLog(@"failed to update user avatar. error:%@", error.description);
                    }
                }];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [view show];
        }
    }];

}
- (IBAction)back:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)avatarTap:(id)sender {
    UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"照片",nil];
    [actionSheet showInView:self.view];
}

//取消键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (self.view == view) {
        [self dismissKeyboard];
    }
}

- (void)dismissKeyboard
{

    [_regsierName resignFirstResponder];
    [_regiserPassWord resignFirstResponder];
    [_email resignFirstResponder];
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
        [self.navigationController presentViewController:picker animated:YES completion:nil];
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
        [self presentViewController:picker animated:YES completion:nil];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    _customeImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
        [_avatar setImage:_customeImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
