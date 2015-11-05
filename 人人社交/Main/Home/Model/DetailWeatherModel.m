//
//  DetailWeatherModel.m
//  SchoolYard
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "DetailWeatherModel.h"

@implementation DetailWeatherModel

+ (DetailWeatherModel *)modelWithDic:(NSMutableDictionary *)dic
{
    DetailWeatherModel *model = [[DetailWeatherModel alloc]init];
    model.cityName = dic[@"cityName"];
    model.weather = dic[@"weather"];
    model.tmp = dic[@"tmp"];
    model.higthTmp = dic[@"higthTmp"];
    model.loseTmp = dic[@"loseTmp"];
    model.date = dic[@"date"];
    model.time = dic[@"time"];
    model.winDirection = dic[@"winDirection"];
    model.winPower = dic[@"winPower"];
    model.water = dic[@"water"];
    model.quality = dic[@"quality"];
    model.clothes =dic[@"clothes"];
    model.wImageStr = dic[@"wImageStr"];
    model.sd = dic[@"sd"];
    return model;
}

@end
