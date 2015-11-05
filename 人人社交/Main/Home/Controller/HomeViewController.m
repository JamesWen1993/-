//
//  HomeViewController.m
//  人人社交
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "QuickListViewController.h"
#import "AVUser+Avatar.h"
#import "CDChatManager.h"
#import "WeatherViewController.h"
#import "AFNetworking.h"
#import "NewsModel.h"
#import "SwaterFlowCollectionView.h"
#import "SwaterFlow.h"
#import "MJRefresh.h"

static CGFloat const kMargin = 10.f;

@interface HomeViewController ()<UIAlertViewDelegate>
{
    NSMutableArray *_wayBillsArray;
    UITableView *_table;
    NSMutableArray *_timeaArray;
    NSMutableArray *_newsArray;
    SwaterFlowCollectionView *_swaterFlowView;
    SwaterFlow *_layout;
    UIImageView *_imageView;
    
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _newsArray = [[NSMutableArray alloc]init];
    self.title = @"主页";
    [self setNavbarItem];
    //创建小插件栏
    [self _createToolsView];
    [self _login];
    //创建加载动画
    [self _createAnimat];
    //获取News
    [self _loadNews];
    
}
- (void)_login {
    if ([AVUser currentUser] == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请登录" message:@"点击登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else {
//        [self showHUD:@"正在加载账号"];
        AVUser* currentUser = [AVUser currentUser];
        
        [[CDChatManager manager] openWithClientId:currentUser.username useravatarUrl:currentUser.avatarUrl callback:^(BOOL succeeded, NSError *error) {
            
            if (error) {
                // 出错了，可能是网络问题无法连接 LeanCloud 云端，请检查网络之后重试。
                // 此时聊天服务不可用。
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"聊天不可用！" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [view show];
                [self presentViewController:[LoginViewController alloc] animated:YES completion:nil];
            } else {
                // 成功登录，可以进入聊天主界面了。
//                [self completeHUD:@"加载完成"];
               
                
            }
        }];
        
    }
    
    
}

- (void)_createSwaterFlowView
{
    if (_swaterFlowView == nil) {
        _swaterFlowView = [[SwaterFlowCollectionView alloc]initWithFrame:CGRectMake(0, 230, kScreenWidth, kScreenHeight-279) collectionViewLayout:[self layout]];
        _swaterFlowView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreNewsDataAction)];
    }
    [self.view addSubview:_swaterFlowView];
}

- (SwaterFlow *)layout {
    if (!_layout) {
        _layout = [[SwaterFlow alloc] init];
        _layout.minimumInteritemSpacing = kMargin;
        _layout.minimumLineSpacing = kMargin;
        _layout.sectionInset = UIEdgeInsetsMake(5, 8, 5, 5);
    }
    return _layout;
}


#pragma mark - 创建小插件View
- (void)_createToolsView
{
    NSArray *buttonImageArray = @[@"icon_gaoshi@2x",
                                  @"icon_kuaidi@2x",
                                  @"icon_weather@2x",
                                  @"icon_gohome@2x",
                                  @"icon_mark@2x",
                                  @"icon_qinglv@2x",
                                  @"icon_sport@2x",
                                  @"icon_xiaoshuo@2x"];
    NSArray *buttonTitleArray = @[@"校园告示",
                                  @"快递小哥",
                                  @"天气查询",
                                  @"我要回家",
                                  @"精品商城",
                                  @"情侣小窝",
                                  @"热爱运动",
                                  @"人气小说"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 70, kScreenWidth-10, 150)];
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowOpacity = 1;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    CGFloat buttonWidth = (kScreenWidth - 10)/4;
    CGFloat imageX = (buttonWidth - 40)/2;
    for (int i=0; i<8; i++) {
        if (i < 4) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*buttonWidth + imageX, 6, 40, 40)];
            button.tag = i + 30;
            [button setImage:[UIImage imageNamed:buttonImageArray[i]] forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(buttonAction:)
             forControlEvents:UIControlEventTouchUpInside];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*buttonWidth, 46, buttonWidth, 29)];
            label.text = buttonTitleArray[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            [view addSubview:label];
            [view addSubview:button];
        }
        else
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((i-4)*buttonWidth + imageX, 75, 40, 40)];
            button.tag = i + 30;
            [button setImage:[UIImage imageNamed:buttonImageArray[i]] forState:UIControlStateNormal];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((i-4)*buttonWidth, 115, buttonWidth, 29)];
            label.text = buttonTitleArray[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            [view addSubview:label];
            [view addSubview:button];
        }
        
    }
}
#pragma mark - 小插件按钮实现功能
- (void)buttonAction:(UIButton *)button
{
    NSInteger buttonTag = button.tag;
    if (buttonTag == 31)
    {
        QuickListViewController *quickView =[[QuickListViewController alloc]init];
        //进入查快递页面
        [self.navigationController pushViewController: quickView animated:YES];
    }
    else if (buttonTag == 32)
    {
        //进入查天气页面
        WeatherViewController *weather = [[WeatherViewController alloc]init];
        [self.navigationController pushViewController:weather animated:YES];
    }
}

#pragma mark - 创建加载动画
- (void)_createAnimat
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-20, 260, 40, 40)];
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        for (int i = 1; i < 5; i++) {
            NSString *string = [NSString stringWithFormat:@"refresh0%i@2x",i];
            UIImage *image = [UIImage imageNamed:string];
            [imageArray addObject:image];
        }
        
        //图片视图的动画数组
        _imageView.animationImages = imageArray;
        _imageView.animationDuration = 0.5;
        
        //动画重复的次数：默认循环播放
        //    _imageView.animationRepeatCount = 3;
        
        //启动动画
        [_imageView startAnimating];
        
        [self.view addSubview:_imageView];
    }
}

#pragma mark - 网络请求新闻
- (void)_loadNews
{
    //新闻网络请求
    AFHTTPRequestOperationManager *mananger = [AFHTTPRequestOperationManager manager];
    NSString *urlString = @"http://apis.baidu.com/txapi/weixin/wxhot";
    NSDictionary *params = @{
                             @"num":@30
                             };
    [mananger.requestSerializer setValue:kApiKey forHTTPHeaderField:@"apikey"];
    [mananger GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        NSArray *keysArray = [result allKeys];
        NSMutableArray *keys = [keysArray mutableCopy];
        [keys removeObject:@"code"];
        [keys removeObject:@"msg"];
        for (NSString *key in keys) {
            NSDictionary *new = [result objectForKey:key];
            NewsModel *model = [[NewsModel alloc]initWithDataDic:new];
            [model changeImageData:model.picUrl];
            [_newsArray addObject:model];
        }
        if (_swaterFlowView == nil) {
            [_imageView stopAnimating];
            _imageView.hidden = NO;
            //创建瀑布流新闻
            [self _createSwaterFlowView];
            _swaterFlowView.dataArray = _newsArray;
        }
        else
        {
            [_swaterFlowView.footer endRefreshing];
            _swaterFlowView.dataArray = _newsArray;
            [_swaterFlowView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
        NSLog(@"xxxx%@",error);
    }];
}

- (void)_loadMoreNewsDataAction
{
    [self _loadNews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex ==1 ) {
        [self presentViewController:[LoginViewController alloc] animated:YES completion:nil];
    }
    
}

@end
