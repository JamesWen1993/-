//
//  BaseNavViewController.m
//  人人社交
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景
    [self setBgImage];
    self.navigationBar.tintColor = [UIColor lightGrayColor];
    //状态栏设置方法一：
    UIApplication *app=[UIApplication sharedApplication];
    //状态栏颜色
    //1.0设置前景色（时间、电池等） 为白色，默认黑色UIStatusBarStyleDefault
    [app setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    //    self.navigationBar.translucent=NO; // 是否透明
    //   self.navigationBar.barStyle = UIBarStyleBlackOpaque; //风格
    
    //是否为全屏布局 iOS7.0之后特性
    //    self.edgesForExtendedLayout=UIRectEdgeNone;
    
}

- (void)setBgImage
{
    //设置背景
    UIColor *titleColor = [UIColor lightGrayColor];
    //设置导航栏背景
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    //导航栏文字设置
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor,
                                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:20]
                                                 }];
    
}
//ios7.0及以后设置状态栏方法
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
@end
