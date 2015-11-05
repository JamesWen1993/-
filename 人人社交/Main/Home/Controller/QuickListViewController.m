//
//  QuickListViewController.m
//  SchoolYard
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "QuickListViewController.h"
#import "AFNetworking.h"
#import "QucikModel.h"
#import "UIViewExt.h"
#import "QuickCompanyViewController.h"
#import "BaseNavViewController.h"

@interface QuickListViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_wayBillsArray;//运单轨迹
    NSMutableArray *_timeaArray;
    QucikModel *_model;
    UITableView *_tableView;
    UITextField *_textField;//订单号
    UIButton *_companyButton;//快递公司名称
    NSString *_companyName;
    NSDictionary *_companyNameDic;
    UIView *_view;
    UILabel *_quickLabel;//返回查询结果
}
@end

@implementation QuickListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查快递";
    //创建查快递View
    [self _createQuickView];
    //创建TableView
    [self _createTableView];
    //设置导航栏返回按钮
    [self _createBackButton];
}
#pragma mark - 设置导航栏返回按钮
- (void)_createBackButton
{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 7, 50, 28)];
    UIImage *image = [UIImage imageNamed:@"button_back@2x"];
    [back setBackgroundImage:image forState:UIControlStateNormal];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    back.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    back.titleLabel.font = [UIFont systemFontOfSize:13];
    [back addTarget:self
             action:@selector(back)
   forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
}
- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 创建查快递View
- (void)_createQuickView
{
    if (_companyName.length == 0) {
        _companyName = @"圆通";
    }
    //圆通：YT，申通：ST，中通：ZT，邮政EMS: YZEMS，天天：TT，优速：YS，快捷：KJ，全峰：QF，增益：ZY
    _companyNameDic = @{@"圆通":@"YT",
                        @"申通":@"ST",
                        @"中通":@"ZT",
                        @"邮政EMS":@"YZEMS",
                        @"天天":@"TT",
                        @"优速":@"YS",
                        @"快捷":@"KJ",
                        @"全峰":@"QF",
                        @"增益":@"ZY"};
    _view = [[UIView alloc]initWithFrame:CGRectMake(5, 70, kScreenWidth-10, 180)];
    _view.layer.shadowColor = [UIColor grayColor].CGColor;
    _view.layer.shadowOffset = CGSizeMake(2, 2);
    _view.layer.shadowOpacity = 1;
    _view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view];
    //小图钉图片视图
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake((_view.bounds.size.width - 13)/2, 5, 13, 15)];
    view.image = [UIImage imageNamed:@"icon_tuding_4@2x"];
    [_view addSubview:view];
    //订单号视图
    UIImageView *numImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, view.bottom + 5, 30, 30)];
    numImageView.image = [UIImage imageNamed:@"quick_num"];
    [_view addSubview:numImageView];
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(40, view.bottom + 5, _view.bounds.size.width - 55, 30)];
    _textField.placeholder = @"运单号...";
    _textField.font = [UIFont systemFontOfSize:13];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.delegate = self;
    [_view addSubview:_textField];
    //快递公司视图
    UIImageView *comImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, numImageView.bottom + 10, 30, 30)];
    comImageView.image = [UIImage imageNamed:@"quick_company"];
    [_view addSubview:comImageView];
    _companyButton = [[UIButton alloc]initWithFrame:CGRectMake(40, numImageView.bottom + 10, _view.bounds.size.width - 55, 30)];
    _companyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _companyButton.layer.cornerRadius = 5;
    _companyButton.layer.shadowColor = [UIColor grayColor].CGColor;
    _companyButton.layer.shadowOffset = CGSizeMake(2, 2);
    _companyButton.layer.shadowOpacity = 1;
    _companyButton.backgroundColor = [UIColor whiteColor];
    [_companyButton setTitle:@"圆通" forState:UIControlStateNormal];
    [_companyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_companyButton addTarget:self
                       action:@selector(selectCompany)
             forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:_companyButton];
    //创建查询按钮
    UIButton *enquiries = [[UIButton alloc]initWithFrame:CGRectMake(35, comImageView.bottom + 10, _view.bounds.size.width - 50, 30)];
    enquiries.layer.shadowColor = [UIColor grayColor].CGColor;
    enquiries.layer.shadowOffset = CGSizeMake(2, 2);
    enquiries.layer.shadowOpacity = 1;
    enquiries.backgroundColor = [UIColor whiteColor];
    [enquiries setTitle:@"点击查询" forState:UIControlStateNormal];
    enquiries.titleLabel.font = [UIFont systemFontOfSize:13];
    [enquiries setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [enquiries addTarget:self
                  action:@selector(enquiriesQuick)
        forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:enquiries];
    //提示Label
    _quickLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, enquiries.bottom + 5, _view.bounds.size.width - 50, 30)];
    _quickLabel.layer.shadowColor = [UIColor grayColor].CGColor;
    _quickLabel.layer.shadowOffset = CGSizeMake(2, 2);
    _quickLabel.layer.shadowOpacity = 1;
    _quickLabel.backgroundColor = [UIColor whiteColor];
    _quickLabel.font = [UIFont systemFontOfSize:13];
    _quickLabel.textAlignment = NSTextAlignmentCenter;
    [_view addSubview:_quickLabel];
}

#pragma mark - 选择快递公司
- (void)selectCompany
{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    QuickCompanyViewController *companyView = [[QuickCompanyViewController alloc]init];
    NSArray *comArray = [_companyNameDic allKeys];
    companyView.companysArray = comArray;
    companyView.comName = _companyName;
    BaseNavViewController *nav = [[BaseNavViewController alloc]initWithRootViewController:companyView];
    [companyView setBlock:^(NSString *comName){
        _companyName = comName;
        [_companyButton setTitle:_companyName forState:UIControlStateNormal];
    }];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - 查询快递
- (void)enquiriesQuick
{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    _quickLabel.text = @"正在以龟速查找您的快件。。。";
    //快递网络请求
    AFHTTPRequestOperationManager *mananger = [AFHTTPRequestOperationManager manager];
    NSString *urlString = @"http://apis.baidu.com/ppsuda/waybillnoquery/waybillnotrace";
    if (_textField.text.length != 0)
    {
        NSString *comName = [_companyNameDic objectForKey:_companyName];
        NSDictionary *params = @{
                                 @"expresscode" : comName,  //快递公司代码YT
                                 @"billno" : _textField.text,//订单号
                                 };
        [mananger.requestSerializer setValue:kApiKey forHTTPHeaderField:@"apikey"];
        [mananger GET:urlString parameters:params success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSArray *dataArray = [responseObject objectForKey:@"data"];
            if (![dataArray[0] isKindOfClass:[NSDictionary class]])
            {
                _quickLabel.text = @"啊哦，未查询到亲的快递";
                _timeaArray = nil;
                _wayBillsArray = nil;
                [_tableView reloadData];
            }
            else
            {
                if (_wayBillsArray == nil) {
                    _wayBillsArray = [[NSMutableArray alloc]init];
                    _timeaArray = [[NSMutableArray alloc]init];
                }
            
               NSDictionary *Datadic = dataArray[0];
               NSString *comN = [Datadic objectForKey:@"expressName"];
               _quickLabel.text = [NSString stringWithFormat:@"%@  %@",comN,@"有您的快件信息，请查收"];
               NSArray *wayBillArray = [Datadic objectForKey:@"wayBills"];//运单轨迹
               for (NSDictionary *dic in wayBillArray)
               {
                   NSString *processInfo = dic[@"processInfo"];
                   NSString *time = dic[@"time"];
                   [_timeaArray insertObject:time atIndex:0];
                   [_wayBillsArray insertObject:processInfo atIndex:0];
               }
                if (_model == nil) {
                    _model = [[QucikModel alloc]initWithDataDic:Datadic];
                }
                else
                {
                    [_model setAttributes:Datadic];
                }
                _model.processInfo = _wayBillsArray;
                _model.time = _timeaArray;
                [_tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"查询快递出错:%@",error);
        }];
    }
}

#pragma mark - 创建显示快递的TableView
- (void)_createTableView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 260, kScreenWidth - 20, kScreenHeight - 270)];
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(3, 3);
    view.layer.shadowOpacity = 1;
    view.backgroundColor = [UIColor colorWithRed:160/225.0 green:127/225.0 blue:224/225.0 alpha:1];
    [self.view addSubview:view];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((view.bounds.size.width - 13)/2, 5, 13, 15)];
    image.image = [UIImage imageNamed:@"icon_tuding_5@2x"];
    [view addSubview:image];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 20, view.bounds.size.width - 30, view.bounds.size.height - 25)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [view addSubview:_tableView];
}
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _wayBillsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    NSString *time = _model.time[indexPath.row];
    NSArray *timeArray = [time componentsSeparatedByString:@":"];
    NSString *hourTime = timeArray[0];
    NSString *minute = timeArray[1];
    NSString *process = _model.processInfo[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@:%@ %@",hourTime,minute,process];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = string;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
#pragma mark - textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
