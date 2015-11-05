//
//  DetailWeatherModel.h
//  SchoolYard
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailWeatherModel : NSObject

@property (nonatomic, copy)NSString *cityName;
@property (nonatomic, copy)NSString *weather;
@property (nonatomic, copy)NSString *tmp;
@property (nonatomic, copy)NSString *higthTmp;
@property (nonatomic, copy)NSString *loseTmp;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *winDirection;
@property (nonatomic, copy)NSString *winPower;
@property (nonatomic, copy)NSString *water;
@property (nonatomic, copy)NSString *quality; //空气质量
@property (nonatomic, copy)NSDictionary *clothes; //穿衣指数
@property (nonatomic, copy)NSString *wImageStr;
@property (nonatomic, copy)NSString *sd;
+ (DetailWeatherModel *)modelWithDic:(NSMutableDictionary *)dic;

@end
