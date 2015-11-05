//
//  QuickCompanyViewController.m
//  SchoolYard
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "QuickCompanyViewController.h"

@interface QuickCompanyViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation QuickCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"空降快递公司";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"companybg.jpeg"]];
    //创建TableView
    [self _createTableView];
    //创建返回按钮
    [self _createBackButton];
}
#pragma mark - 设置导航栏返回按钮
- (void)_createBackButton
{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 40, 10, 20, 20)];
    UIImage *image = [UIImage imageNamed:@"icon_closed@2x"];
    [back setBackgroundImage:image forState:UIControlStateNormal];
    [back addTarget:self
             action:@selector(back)
   forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = backItem;
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 创建TableView
- (void)_createTableView
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(10, 69, kScreenWidth - 20, kScreenHeight - 74) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"company"];
    [self.view addSubview:table];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_companysArray != nil) {
         return _companysArray.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"company" forIndexPath:indexPath];
    if (indexPath.row%2 == 0) {
        cell.imageView.image = [UIImage imageNamed:@"company2@2x"];
    }
    else
    {
       cell.imageView.image = [UIImage imageNamed:@"company1@2x"];
    }
    if ([_companysArray[indexPath.row] isEqualToString:_comName]) {
        cell.imageView.hidden = NO;
    }
    else
    {
        cell.imageView.hidden = YES;
    }
    cell.textLabel.text = _companysArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^{
        _block(_companysArray[indexPath.row]);
    }];
    
}
@end
