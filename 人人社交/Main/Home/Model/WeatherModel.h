//
//  WeatherModel.h
//  SchoolYard
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "BaseModel.h"
/*
 "day": "20151028",
 "day_air_temperature": "15",
 "day_weather": "晴",
 "day_weather_pic": "http://app1.showapi.com/weather/icon/day/00.png",
 "day_wind_direction": "无持续风向",
 "day_wind_power": "微风<10m/h",
 "jiangshui": "1%",
 "night_air_temperature": "5",
 "night_weather": "晴",
 "night_weather_pic": "http://app1.showapi.com/weather/icon/night/00.png",
 "night_wind_direction": "北风",
 "night_wind_power": "3-4级10~17m/h",
 "sun_begin_end": "06:38|17:18",
 "weekday": 3,
 "ziwaixian": "中等"

 */
@interface WeatherModel : BaseModel

@property (nonatomic, strong)NSString *day; //发布日期
@property (nonatomic, strong)NSString *day_air_temperature;//最高温度
@property (nonatomic, strong)NSString *day_weather;//白天天气
@property (nonatomic, strong)NSString *day_weather_pic;//白天天气图片URL
@property (nonatomic, strong)NSString *day_wind_direction;//白天风向
@property (nonatomic, strong)NSString *day_wind_power;//白天风力
@property (nonatomic, strong)NSString *jiangshui;//降水
@property (nonatomic, strong)NSString *night_air_temperature;//最低温度
@property (nonatomic, strong)NSString *night_weather;//晚间天气
@property (nonatomic, strong)NSString *night_weather_pic;//晚间天气图片URL
@property (nonatomic, strong)NSString *night_wind_direction;//晚间风向
@property (nonatomic, strong)NSString *night_wind_power;//晚间风力
@property (nonatomic, strong)NSNumber *weekday;//星期几
@property (nonatomic, strong)NSString *ziwaixian;//紫外线
@property (nonatomic, strong)NSDictionary *index;//穿衣建议

@end
