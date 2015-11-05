//
//  MainTabBarViewController.m
//  人人社交
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "BaseNavViewController.h"
#import "UIViewExt.h"

@interface MainTabBarViewController ()<UITabBarControllerDelegate>
{
    NSArray *_himageArray;
    NSArray *_imageArray;
}
@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载子控制器
    [self _createSubControllers];
    //创建tabBar
    [self _createTabBar];
}

#pragma mark - 加载子控制器
- (void)_createSubControllers
{
    NSArray *subNames = @[@"Home",@"Nearby",@"Friends",@"More"];
    NSMutableArray *subControllers = [[NSMutableArray alloc]init];
    for (int i=0; i<subNames.count; i++) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:subNames[i] bundle:nil];
        BaseNavViewController *nav = [storyBoard instantiateInitialViewController];
        [subControllers addObject:nav];
    }
    self.viewControllers = subControllers;
    self.delegate = self;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:255/255.0 green:160/255.0 blue:0 alpha:1];
}

#pragma mark - 创建tabBar
- (void)_createTabBar
{
    //创建数组存放button图片和标题;
    NSArray *titArray = @[@"主页",@"附近",@"好友",@"我的"];
    _imageArray = @[@"icon_home",@"icon_friend",@"icon_nearby",@"icon_myself"];
    _himageArray = @[@"icon_home_h",@"icon_friend_h",@"icon_nearby_h",@"icon_myself_h"];
    CGFloat width = kScreenWidth/4;
    for (int i=0; i<4; i++) {
        UITabBarItem *button = [self.tabBar.items objectAtIndex:i];
        button.title = titArray[i];
        button.tag = i + 10;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*width+37, 10, 21, 21)];
        imageView.left = i*width + (width/2) - 10.5;
        if (i == 0) {
            imageView.image = [UIImage imageNamed:_himageArray[i]];
        }
        else
        {
            imageView.image = [UIImage imageNamed:_imageArray[i]];
        }
        imageView.tag = i + 20;
        [self.tabBar addSubview:imageView];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger tagId = item.tag + 10;
    for (int i=0; i<4; i++) {
        NSInteger imageTag = i + 20;
        UIImageView *imageView = (UIImageView *)[self.tabBar viewWithTag:imageTag];
        if (imageTag == tagId) {
            imageView.image = [UIImage imageNamed:_himageArray[i]];
        }
        else
        {
            imageView.image = [UIImage imageNamed:_imageArray[i]];
        }
    }
}
@end
