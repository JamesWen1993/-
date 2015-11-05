//
//  MapViewController.m
//  人人社交
//
//  Created by huiwenjiaoyu on 15/10/29.
//  Copyright © 2015年 huiwen. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController (){
    
    MKMapView *_mapView;
    CLLocationManager *_locationManager;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    _locationManager = [[CLLocationManager alloc] init];
    if (kVersion > 8.0) {
        
        [_locationManager requestWhenInUseAuthorization];
    }

    //设置请求的准确度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];

    
    [self _createMapView];
}




- (void)_createMapView{
 
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    //显示用户位置
    _mapView.showsUserLocation = YES;
    
    //地图种类
    _mapView.mapType = MKMapTypeStandard;
    
    //用户跟踪模式
     _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //代理
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    //单击地图创建标注
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapPress:)];
    [_mapView addGestureRecognizer:tap];
    
}

//单击地图 方法
- (void)_tapPress:(UITapGestureRecognizer *)gestureRecognizer{
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D coordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.longitude longitude:coordinate.latitude];
//    
//    //内置反编码
//    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error != nil) {
//            NSLog(@"error = %@", error);
//        }else{
//            
//            CLPlacemark *place = [placemarks lastObject];
//            NSString *title = place.name;
//            NSLog(@"%@",title);
//        }
//    }];
    
    self.lonStr = [NSString stringWithFormat:@"%lf", coordinate.longitude];
    self.latStr = [NSString stringWithFormat:@"%lf", coordinate.latitude];
    
    _block(self.lonStr, self.latStr);
    
    NSLog(@"%@  %@", _lonStr, _latStr);
    
    //block传数据
    
    
    
    //移除上一个标注 并添加新的标注
    [_mapView removeAnnotations:_mapView.annotations];
    [self _createAnnotation:coordinate];
    
}

//添加标注
- (void)_createAnnotation:(CLLocationCoordinate2D )coordinate{
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = coordinate;
    
    pointAnnotation.title = @"经纬度是：";
    pointAnnotation.subtitle = [NSString stringWithFormat:@"%f, %f",coordinate.longitude,coordinate.latitude];
    
    [_mapView addAnnotation:pointAnnotation];
}

#pragma mark - mapView 代理

//位置更新后被调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度 %lf 纬度 %lf",coordinate.longitude,coordinate.latitude);
    
    
    //设置地图的显示区域
    CLLocationCoordinate2D  center = coordinate;
    //数值越小 越精确
    MKCoordinateSpan span = {0.5,0.5};
    MKCoordinateRegion  region = {center,span};

    mapView.region = region;
}

-(void)viewDidDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
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
