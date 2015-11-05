//
//  WeatherViewController.m
//  SchoolYard
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "WeatherViewController.h"
#import "AFNetworking.h"
#import "WeatherModel.h"
#import "UIViewExt.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+WebCache.h"
#import "WeekWeatherCell.h"
#import "DetailWeatherModel.h"
#import "DetailWeatherView.h"

@interface WeatherViewController ()<UITextFieldDelegate,CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSString *_cityid;
    NSString *_cityName;
    NSString *_nowTemperature;
    NSString *_nowWeather_pic;
    WeatherModel *_model;
    BOOL _isOne;
    UILabel *_cityNameLabel;
    UILabel *_weatherLabel;
    UILabel *_tmpLabel;
    UILabel *_promptView;
    UIImageView *_weatherView;
    UITextField *_cityTextField;
    CLLocationManager *_locationManager;//定位管理对象
    NSMutableArray *_modelArray;
    UIView *_weekView;//七天天气预报
    UICollectionView *_collectionView;
    DetailWeatherView *_detailView;
}
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查天气";
    _modelArray = [[NSMutableArray alloc]init];
    _isOne = YES;
    //设置导航栏返回按钮
    [self _createBackButton];
    //设置背景
    [self _setBackgImage];
    //当前城市天气详情
    [self _createWeatherShow];
    //创建查询按钮
    [self _enButton];
    //定位获取用户当前位置
    [self _positionLocation];
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

#pragma mark - 设置界面背景
- (void)_setBackgImage
{
    //获取当前时间
    NSDate *nowDate = [NSDate date];
    //日期格式化
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置日期格式
    [formatter setDateFormat:@"dd:HH:mm:ss"];
    //设置时区
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *localTime = [formatter stringFromDate:nowDate];
    NSArray *hmsArray = [localTime componentsSeparatedByString:@":"];
    NSInteger day = [hmsArray[0] integerValue];
    [self _createDay:day];
    NSInteger hour = [hmsArray[1] integerValue];
    if (hour < 17 && hour > 6)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"weatherDay@2x"]];
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"weatherNight@2x"]];
    }
}

#pragma mark - 设置日期
- (void)_createDay:(NSInteger)day
{
    for (NSInteger i = 1; i < 32; i++) {
        if (day == i) {
            NSInteger day0 = day/10;
            NSInteger day1 = day%10;
            NSString *imageName0 = [NSString stringWithFormat:@"Number_%li_b@2x",day0];
            NSString *imageName1 = [NSString stringWithFormat:@"Number_%li_b@2x",day1];
            UIImageView *imageView0 = [[UIImageView alloc]initWithFrame:CGRectMake(70, 170, 22.5, 45)];
            imageView0.image = [UIImage imageNamed:imageName0];
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(92.5, 170, 22.5, 45)];
            imageView1.image = [UIImage imageNamed:imageName1];
            [self.view addSubview:imageView0];
            [self.view addSubview:imageView1];
        }
    }
}

#pragma mark - 创建查询天气按钮
- (void)_enButton
{
    _promptView = [[UILabel alloc]initWithFrame:CGRectMake(10, 270, kScreenWidth - 20, 40)];
    _promptView.backgroundColor = [UIColor whiteColor];
    _promptView.layer.shadowColor = [UIColor grayColor].CGColor;
    _promptView.layer.shadowOffset = CGSizeMake(2, 2);
    _promptView.layer.shadowOpacity = 1;
    _promptView.font = [UIFont systemFontOfSize:15];
    _promptView.textAlignment = NSTextAlignmentCenter;
    _promptView.textColor = [UIColor grayColor];
    [self.view addSubview:_promptView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 270, kScreenWidth - 20, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowOpacity = 1;
    [self.view addSubview:view];
    _cityTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, view.bounds.size.width - 70, 30)];
    _cityTextField.placeholder = @"输入城市名...";
    _cityTextField.font = [UIFont systemFontOfSize:13];
    _cityTextField.backgroundColor = [UIColor whiteColor];
    _cityTextField.clearButtonMode = UITextFieldViewModeAlways;
    _cityTextField.borderStyle = UITextBorderStyleRoundedRect;
    _cityTextField.delegate = self;
    [view addSubview:_cityTextField];
    UIButton *enbutton = [[UIButton alloc]initWithFrame:CGRectMake(_cityTextField.right + 5, 5, view.bounds.size.width - _cityTextField.right - 10, 30)];
    enbutton.titleLabel.font = [UIFont systemFontOfSize:12];
    enbutton.backgroundColor = [UIColor whiteColor];
    enbutton.layer.shadowColor = [UIColor grayColor].CGColor;
    enbutton.layer.shadowOffset = CGSizeMake(2, 2);
    enbutton.layer.shadowOpacity = 1;
    enbutton.layer.cornerRadius = 5;
    [enbutton setTitle:@"天气一下" forState:UIControlStateNormal];
    [enbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [enbutton addTarget:self
                 action:@selector(enAction)
       forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:enbutton];


}
- (void)enAction
{
    if ([_cityTextField isFirstResponder]) {
        [_cityTextField resignFirstResponder];
    }
    [UIView animateWithDuration:0.5 animations:^{
        _promptView.text = @"正在为您查询今天的天气...";
        _promptView.transform = CGAffineTransformMakeTranslation(0, 50);
    }];
    if (_cityTextField.text.length > 0) {
        _cityName = _cityTextField.text;
        [self _loadCityID];
    }
    else
    {
        [self showPromptView:@"城市名字不能为空哦"];
    }
}

#pragma mark - 查询城市id
- (void)_loadCityID
{
    //查询城市id
    AFHTTPRequestOperationManager *mananger = [AFHTTPRequestOperationManager manager];
    NSString *urlString = @"http://apis.baidu.com/showapi_open_bus/weather_showapi/areaid";
    NSDictionary *params = @{
                             @"area":_cityName
                             };
    [mananger.requestSerializer setValue:kApiKey forHTTPHeaderField:@"apikey"];
    [mananger GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result) {
        NSDictionary *dic = [result objectForKey:@"showapi_res_body"];
        NSArray *list = [dic objectForKey:@"list"];
        if (list.count == 0)
        {
            [self showPromptView:@"无法查询到城市信息"];
        }
        else
        {
            NSDictionary *areaDic = [list objectAtIndex:0];
            _cityid = [areaDic objectForKey:@"areaid"];
            [self _loadWeather];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
        [self showPromptView:@"查询城市信息网络出错"];
    }];
}
- (void)showPromptView:(NSString *)string
{
    [UIView animateWithDuration:0.6 animations:^{
        [UIView setAnimationDelay:1];
        _promptView.text = string;
        _promptView.transform = CGAffineTransformIdentity;
    }];
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

#pragma mark - 查询天气方法
- (void)_loadWeather
{
    if (_cityid == nil) {
        //默认查询杭州市
        _cityid = @"101210101";
    }
    //天气网络请求
    AFHTTPRequestOperationManager *mananger = [AFHTTPRequestOperationManager manager];
    NSString *urlString = @"http://apis.baidu.com/showapi_open_bus/weather_showapi/address";
    NSDictionary *params = @{
                             @"areaid":_cityid,
                             @"needMoreDay":@"1",
                             @"needIndex":@"1"
                             };
    [mananger.requestSerializer setValue:kApiKey forHTTPHeaderField:@"apikey"];
    [mananger GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result) {
         NSDictionary *weatherData = [result objectForKey:@"showapi_res_body"];
        NSDictionary *nowData = [weatherData objectForKey:@"now"];
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        _modelArray = [[NSMutableArray alloc]init];
        NSDictionary *now = [weatherData objectForKey:@"now"];
        _nowTemperature = [now objectForKey:@"temperature"];
        _nowWeather_pic = [now objectForKey:@"weather_pic"];
        if (_isOne) {
            [self _showTodayWeather];
            _isOne = !_isOne;
        }
        for (int i=1; i<8; i++) {
            NSString *keyString = [NSString stringWithFormat:@"f%i",i];
            NSDictionary *f = [weatherData objectForKey:keyString];
            [dataArray addObject:f];
        }
        for (NSDictionary *dic in dataArray) {
            _model = [[WeatherModel alloc]initWithDataDic:dic];
            [_modelArray addObject:_model];
        }
        [self _setDetailWeather:nowData];
        [_collectionView reloadData];
        [self showPromptView:@"为您奉上今日天气"];
    } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
        [self showPromptView:@"获取天气信息网络出错"];
    }];
}

#pragma mark - 解析今日天气详情
- (void)_setDetailWeather:(NSDictionary *)dic
{
    WeatherModel *model = _modelArray[0];
    //创建今日天气详情model
    NSMutableDictionary *detailWeathDic = [[NSMutableDictionary alloc]init];
    
    NSString *tmp = [dic objectForKey:@"temperature"];
    NSString *tmpString = [NSString stringWithFormat:@"%@℃",tmp];
    NSString *htmp = model.day_air_temperature;
    NSString *htmpString = [NSString stringWithFormat:@"%@℃",htmp];
    NSString *ltmp = model.night_air_temperature;
    NSString *ltmpString = [NSString stringWithFormat:@"%@℃",ltmp];
    NSString *dateString = model.day;
    NSString *mon = [dateString substringFromIndex:4];
    NSString *yue = [mon substringToIndex:2];
    NSString *day = [dateString substringFromIndex:6];
    NSString *year = [dateString substringToIndex:4];
    NSString *date = [NSString stringWithFormat:@"%@/%@/%@",yue,day,year];
    NSDictionary *api = [dic objectForKey:@"aqiDetail"];
    NSString *quality = [api objectForKey:@"quality"];
    NSString *water = model.jiangshui;
    NSDictionary *index = model.index;
    NSDictionary *clothes = [index objectForKey:@"clothes"];
    
    [detailWeathDic setObject:_cityName forKey:@"cityName"];
    [detailWeathDic setObject:[dic objectForKey:@"weather"] forKey:@"weather"];
    [detailWeathDic setObject:tmpString forKey:@"tmp"];
    [detailWeathDic setObject:htmpString forKey:@"higthTmp"];
    [detailWeathDic setObject:ltmpString forKey:@"loseTmp"];
    [detailWeathDic setObject:date forKey:@"date"];
    [detailWeathDic setObject:[dic objectForKey:@"temperature_time"] forKey:@"time"];
    [detailWeathDic setObject:[dic objectForKey:@"wind_direction"] forKey:@"winDirection"];
    [detailWeathDic setObject:[dic objectForKey:@"wind_power"] forKey:@"winPower"];
    [detailWeathDic setObject:water forKey:@"water"];
    [detailWeathDic setObject:quality forKey:@"quality"];
    [detailWeathDic setObject:clothes forKey:@"clothes"];
    [detailWeathDic setObject:[dic objectForKey:@"weather_pic"] forKey:@"wImageStr"];
    [detailWeathDic setObject:[dic objectForKey:@"sd"] forKey:@"sd"];
     DetailWeatherModel *detailModel = [DetailWeatherModel modelWithDic:detailWeathDic];
     _detailView.model = detailModel;
}
#pragma mark - 创建天气展示界面
- (void)_createWeatherShow
{
    //今日天气详情View
    UIView *todayView = [[UIView alloc]initWithFrame:CGRectMake(10, 320, kScreenWidth/2-15, kScreenHeight-380)];
    todayView.backgroundColor = [UIColor colorWithRed:238/255.0 green:160/255.0 blue:138/255.0 alpha:1];
    todayView.layer.shadowColor = [UIColor grayColor].CGColor;
    todayView.layer.shadowOffset = CGSizeMake(2, 2);
    todayView.layer.shadowOpacity = 1;
    [self.view addSubview:todayView];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake((todayView.bounds.size.width-13)/2, 0, 13, 15)];
    topImage.image = [UIImage imageNamed:@"icon_tuding_0@2x"];
    [todayView addSubview:topImage];
    if (_detailView == nil) {
        _detailView = [[DetailWeatherView alloc]initWithFrame:CGRectMake(0, 20, todayView.bounds.size.width, todayView.bounds.size.height-20)];
        _detailView.backgroundColor = [UIColor clearColor];
        [todayView addSubview:_detailView];
    }
    //未来七天天气View
    _weekView = [[UIView alloc]initWithFrame:CGRectMake(todayView.right+8, todayView.top+10, kScreenWidth-todayView.right-18, kScreenHeight-340)];
    _weekView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_weekView];
    //创建滑动视图
    [self _createCollectionView];
    //提示View
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, todayView.bottom+5, todayView.right-10, _weekView.bottom-todayView.bottom-5)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowOpacity = 1;
    [self.view addSubview:view];
    UIImageView *vtopImage = [[UIImageView alloc]initWithFrame:CGRectMake((view.bounds.size.width-13)/2, 0, 13, 15)];
    vtopImage.image = [UIImage imageNamed:@"icon_tuding_1@2x"];
    [view addSubview:vtopImage];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, view.bounds.size.width-20, view.bounds.size.height-20)];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"向右看预知未来";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(view.bounds.size.width-28, 15, 20, 20)];
    rightImage.image = [UIImage imageNamed:@"icon_Share@2x"];
    [view addSubview:rightImage];
}

- (void)_createCollectionView
{
    //创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局规则
    flowLayout.minimumLineSpacing = 5;
    flowLayout.itemSize = CGSizeMake(140, 160);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _collectionView = [[UICollectionView alloc]initWithFrame:_weekView.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [_weekView addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"WeekWeatherCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"WeekWeatherCell"];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeekWeatherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeekWeatherCell" forIndexPath:indexPath];
    if (_modelArray.count != 0) {
        cell.model = _modelArray[indexPath.item+1];
    }
    return cell;
}
- (void)_showTodayWeather
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(225, 166, 60, 62)];
    [self.view addSubview:view];
    if (_cityNameLabel == nil) {
        _cityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 35, 20)];
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        _cityNameLabel.font = [UIFont systemFontOfSize:11];
        [view addSubview:_cityNameLabel];
    }
    if (_tmpLabel == nil) {
        _tmpLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 40, 25, 20)];
        _tmpLabel.font = [UIFont systemFontOfSize:9];
        [view addSubview:_tmpLabel];
    }
    if (_weatherView == nil) {
        _weatherView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 35, 35)];
        [view addSubview:_weatherView];
    }
    _cityNameLabel.text = _cityName;
    _tmpLabel.text = [NSString stringWithFormat:@"%@℃",_nowTemperature];
    [_weatherView sd_setImageWithURL:[NSURL URLWithString:_nowWeather_pic]];
}


#pragma mark - 定位用户当前位置
- (void)_positionLocation
{
    [UIView animateWithDuration:0.5 animations:^{
        _promptView.text = @"正在为您查询当前城市天气...";
        _promptView.transform = CGAffineTransformMakeTranslation(0, 50);
    }];
    //初始化位置管理类
    /*
     plist文件加入
     NSLocationWhenInUseUsageDescription  BOOL  YES
     NSLocationAlwaysUsageDescription  String 任意
    */
    _locationManager = [[CLLocationManager alloc]init];
    //设置代理
    _locationManager.delegate = self;
    //设置精确度到米/设备使用电池时最精确定位
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置过滤器，若为None则每秒定位一次耗电(可设置1000米定位一次)
    _locationManager.distanceFilter = 1000.0f;
    if (kVersion >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    //开始定位
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //停止定位
    [manager stopUpdatingLocation];
    //获取地理位置信息
    CLLocation *location = [locations lastObject];
    //获取经纬度
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSString *longitude = [NSString stringWithFormat:@"%lf",coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%lf",coordinate.latitude];
    NSLog(@"经度:%@ 纬度:%@",longitude,latitude);
    //反向编译地址  速度慢
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市
                city = placemark.administrativeArea;
            }
            //计算字符串长度
            NSUInteger length = [city length];
            city = [city substringToIndex:length-1];
            _cityName = city;
            NSLog(@"%@",_cityName);
            //查询城市id
            [self _loadCityID];
        }
        else if (error == nil && placemarks == 0)
        {
            [self showPromptView:@"没定位到当前城市"];
        }
        else if (error != nil)
        {
            [self showPromptView:@"定位出现了错误"];
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self _setBackgImage];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    
}
@end
