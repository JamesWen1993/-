//
//  MapViewController.h
//  人人社交
//
//  Created by huiwenjiaoyu on 15/10/29.
//  Copyright © 2015年 huiwen. All rights reserved.
//


#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
typedef void(^CoordinateBlock)(NSString *, NSString *);

@interface MapViewController : BaseViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, assign)NSString *lonStr;
@property (nonatomic, assign)NSString *latStr;

@property (nonatomic, copy)CoordinateBlock block;
@end
