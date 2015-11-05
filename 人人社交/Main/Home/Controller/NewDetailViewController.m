//
//  NewDetailViewController.m
//  SchoolYard
//
//  Created by mac on 15/10/30.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "NewDetailViewController.h"

@interface NewDetailViewController ()

@end

@implementation NewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"娱乐新闻";
    //系统自带浏览器打开
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_model.url]];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+49)];
    webView.backgroundColor = [UIColor whiteColor];
    //    1.构造URL
    NSURL *url = [NSURL URLWithString:_model.url];
    
    //    2.构造NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

@end
