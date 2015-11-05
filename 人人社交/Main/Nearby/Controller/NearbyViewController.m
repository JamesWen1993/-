//
//  NearbyViewController.m
//  人人社交
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "NearbyViewController.h"
#import "SendViewController.h"
#import "TableViewCell.h"
#import "ActivityDetailVc.h"
#import "MoreViewController.h"
#import "ActivityModel.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MJRefresh.h"
#import "AVUser+Avatar.h"
#import "UIImageView+AFNetworking.h"


@interface NearbyViewController (){
    
    UITableView *_tableView;
    
    SendViewController *_sendVc;
    MoreViewController *_moreVc;
    NSMutableArray *_modelArray;
    ActivityModel *_model;
    UIImageView *_imageView;
    
    
}

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _modelArray = [[NSMutableArray alloc]init];
    
    self.title = @"附近";
    //创建加载动画
    [self _createAnimat];
    [self _loadData];
    
    [self _createView];
    [self _createBarButton];
}

#pragma mark - 创建加载动画
- (void)_createAnimat
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-20, 64, 40, 40)];
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        for (int i = 1; i < 5; i++) {
            NSString *string = [NSString stringWithFormat:@"refresh0%i@2x",i];
            UIImage *image = [UIImage imageNamed:string];
            [imageArray addObject:image];
        }
        
        //图片视图的动画数组
        _imageView.animationImages = imageArray;
        _imageView.animationDuration = 0.5;
        
        //启动动画
        [_imageView startAnimating];
        
        [self.view addSubview:_imageView];
    }
    
}


- (void)_createView{
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TableViewCell"];
    [self.view addSubview:_tableView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self _loadNewData];
}
#pragma mark UITableView + 下拉刷新 默认

- (void)_loadNewData {
    
    //向服务器请求数据
    AVQuery *query = [AVQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        NSMutableArray *newArray = [[NSMutableArray alloc]init];
        NSDictionary *loc = [objects valueForKey:@"localData"];
        NSArray *objectIds = [objects valueForKey:@"objectId"];

        int i = 0;
        for (NSDictionary *dic in loc) {
            NSMutableDictionary *dataDic = [dic mutableCopy];
            [dataDic setObject:objectIds[i] forKey:@"objectId"];
            i++;
            _model = [[ActivityModel alloc] initWithDataDic:dataDic];
            [newArray addObject:_model];
        }
        
        
        _modelArray = newArray;

        [_tableView reloadData];
        [_tableView.header endRefreshing];
    }];
    
    
}

- (void)_createBarButton{
    
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"我要发布" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutItem;
}

//发布活动
- (void)logout {

    [self.navigationController pushViewController:_sendVc animated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    //背景
    cell.backgroundColor = [UIColor clearColor];
    //圆角
    cell.bgView.layer.cornerRadius = 6;
    cell.headView.layer.cornerRadius = 20;
    //点击颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //头像和昵称
    AVUser *user = [AVUser currentUser];
    cell.nickNameLabel.text = user.username;
    [cell.headView setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"Upload_avata@3x"]];
    cell.model = _modelArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //活动详情View
    ActivityDetailVc *activityDetail = [[ActivityDetailVc alloc] init];
    
    activityDetail.model = _modelArray[indexPath.row];
    
    [self.navigationController pushViewController:activityDetail animated:YES];
    
}

-(void)_loadData{
    
    _moreVc = [[MoreViewController alloc] init];
    _sendVc = [[SendViewController alloc]init];
    
    //向服务器请求数据
    AVQuery *query = [AVQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        NSDictionary *loc = [objects valueForKey:@"localData"];

        for (NSDictionary *dic in loc) {
            ActivityModel *model = [[ActivityModel alloc] initWithDataDic:dic];
            [_modelArray addObject:model];
        }
        [_imageView stopAnimating];
        [_tableView reloadData];
    }];
    
    [_tableView reloadData];
    
    
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
