//
//  BaseViewController.m
//  人人社交
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    MBProgressHUD *_hud;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景
    [self setBgColor];
}
- (void)setBgColor
{
    //设置背景
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
}
//设置NavBarItem
- (void)setNavbarItem
{
    //左侧按钮创建
    _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_leftButton setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [_leftButton addTarget:self
                    action:@selector(setAction)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    //右侧按钮创建
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-45, 0, 44, 44)];
    [_rightButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [_rightButton addTarget:self
                     action:@selector(editAction)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)setAction
{
    MMDrawerController *mmdraw = self.mm_drawerController;
    [mmdraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)editAction
{
    MMDrawerController *mmdraw = self.mm_drawerController;
    [mmdraw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

//显示加载
- (void)showHUD:(NSString *)title{
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.labelText = title;
    [_hud show:YES];
    //灰色背景视图覆盖掉其他视图
    _hud.dimBackground = YES;
}
//隐藏
- (void)hideHUD {
    [_hud hide:YES];
}
- (void)completeHUD:(NSString *)title {
    _hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    
    //持续1.5隐藏
    [_hud hide:YES afterDelay:1.5];
}



@end
