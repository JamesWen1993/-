//
//  WeekWeatherCell.m
//  SchoolYard
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "WeekWeatherCell.h"
#import "UIImageView+WebCache.h"

@implementation WeekWeatherCell

- (void)setModel:(WeatherModel *)model
{
    if (_model != model) {
        NSDictionary *weekDic = @{
                                  @"1":@"一",
                                  @"2":@"二",
                                  @"3":@"三",
                                  @"4":@"四",
                                  @"5":@"五",
                                  @"6":@"六",
                                  @"7":@"日",
                                  };
        _model = model;
        _weatherLabel.text = _model.day_weather;
        [_weatherImage sd_setImageWithURL:[NSURL URLWithString:_model.day_weather_pic]];
        _tmpLabel.text = [NSString stringWithFormat:@"%@℃~%@℃",_model.night_air_temperature,_model.day_air_temperature];
        _tmpLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:15];
        NSString *dateString = _model.day;
        NSString *mon = [dateString substringFromIndex:4];
        NSString *yue = [mon substringToIndex:2];
        NSString *day = [dateString substringFromIndex:6];
        NSString *year = [dateString substringToIndex:4];
        _dateLabel.text = [NSString stringWithFormat:@"%@/%@/%@",yue,day,year];
        _dateLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:12];
        NSNumber *weekNum = _model.weekday;
        NSString *weekStr = [weekNum stringValue];
        NSString *week = [weekDic objectForKey:weekStr];
        _weekLabel.text = [NSString stringWithFormat:@"星期%@",week];
        _winLabel.text = [NSString stringWithFormat:@"%@ %@",_model.day_wind_direction,_model.day_wind_power];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

@end
