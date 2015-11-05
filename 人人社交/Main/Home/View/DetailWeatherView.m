//
//  DetailWeatherView.m
//  SchoolYard
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "DetailWeatherView.h"
#import "DetailWeatherModel.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"

@interface DetailWeatherView()
{
    UILabel *_cityLabel;
    UILabel *_tmpLabel;
    UILabel *_weatherLabel;
    UILabel *_higthtmpLabel;
    UILabel *_losetmpLabel;
    UILabel *_datelabel;
    UILabel *_timeLabel;
    UILabel *_winLabel;
    UILabel *_waterlabel;
    UILabel *_qualityLabel;
    UILabel *_clotheslabel;
    UILabel *_coollabel;
    UILabel *_sdLabel;
    UIImageView *_weatherImageView;
    UIImageView *_waterImageView;
    UIImageView *_tmpImageView;
    UIImageView *_winImageView;
    UIImageView *_clothesImageView;
    UIImageView *_lineView;
}
@end
@implementation DetailWeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2-5, 30)];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_cityLabel];
        _datelabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-5, 0, self.bounds.size.width/2+5, 15)];
        _datelabel.textAlignment = NSTextAlignmentCenter;
        _datelabel.textColor = [UIColor whiteColor];
        _datelabel.font = [UIFont fontWithName:@"Chalkboard SE" size:10];
        [self addSubview:_datelabel];
        _timeLabel= [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-5, 15, self.bounds.size.width/2+5, 15)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:10];
        [self addSubview:_timeLabel];
        _tmpLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, self.bounds.size.width/2-10, 35)];
        _tmpLabel.textAlignment = NSTextAlignmentRight;
        _tmpLabel.textColor = [UIColor whiteColor];
        _tmpLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:30];
        [self addSubview:_tmpLabel];
        _weatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, self.bounds.size.width/2-10, 30)];
        _weatherLabel.textAlignment = NSTextAlignmentRight;
        _weatherLabel.textColor = [UIColor whiteColor];
        _weatherLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:_weatherLabel];
        _lineView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-6, 35, 1, 75)];
        _lineView.backgroundColor = [UIColor clearColor];
        [self addSubview:_lineView];
        _weatherImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 60, 35, 45, 45)];
        _weatherImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_weatherImageView];
        _sdLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, 75, self.bounds.size.width/2 - 5, 20)];
        _sdLabel.font = [UIFont systemFontOfSize:10];
        _sdLabel.textColor = [UIColor whiteColor];
        _sdLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_sdLabel];
        _qualityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, 95, self.bounds.size.width/2 - 5, 20)];
        _qualityLabel.textColor = [UIColor whiteColor];
        _qualityLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_qualityLabel];
        _tmpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 20, 30)];
        _tmpImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tmpImageView];
        _higthtmpLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 115, 35, 30)];
        _higthtmpLabel.backgroundColor = [UIColor clearColor];
        _higthtmpLabel.textColor = [UIColor whiteColor];
        _higthtmpLabel.textAlignment = NSTextAlignmentRight;
        _higthtmpLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:15];
        [self addSubview:_higthtmpLabel];
        _losetmpLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 115, 40, 30)];
        _losetmpLabel.backgroundColor = [UIColor clearColor];
        _losetmpLabel.textColor = [UIColor whiteColor];
        _losetmpLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:13];
        [self addSubview:_losetmpLabel];
        
        _waterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 150, 20, 30)];
        _waterImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_waterImageView];
        _waterlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 150, 50, 30)];
        _waterlabel.backgroundColor = [UIColor clearColor];
        _waterlabel.textColor = [UIColor whiteColor];
        _waterlabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_waterlabel];
        
        _winImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 185, 20, 30)];
        _winImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_winImageView];
        _winLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 185, self.bounds.size.width-45, 30)];
        _winLabel.backgroundColor = [UIColor clearColor];
        _winLabel.textColor = [UIColor whiteColor];
        _winLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_winLabel];
        
        _clothesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 225, 20, 30)];
        _clothesImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_clothesImageView];
        _coollabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 220, 40, 30)];
        _coollabel.backgroundColor = [UIColor clearColor];
        _coollabel.textColor = [UIColor whiteColor];
        _coollabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_coollabel];
        _clotheslabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 220, self.bounds.size.width-85, 40)];
        _clotheslabel.numberOfLines = 0;
        _clotheslabel.backgroundColor = [UIColor clearColor];
        _clotheslabel.textColor = [UIColor whiteColor];
        _clotheslabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_clotheslabel];
    }
    return self;
}

- (void)setModel:(DetailWeatherModel *)model
{
    if (_model != model) {
        _model = model;
        //更新UI
        [self _setSubViews];
    }
}

- (void)_setSubViews
{
    _cityLabel.text = _model.cityName;
    _tmpLabel.text = _model.tmp;
    _weatherLabel.text = _model.weather;
    _lineView.image = [UIImage imageNamed:@"weatherline"];
    _sdLabel.text = [NSString stringWithFormat:@"湿度: %@",_model.sd];
    _higthtmpLabel.text = _model.higthTmp;
    _losetmpLabel.text = [NSString stringWithFormat:@"/%@",_model.loseTmp];
    _datelabel.text = _model.date;
    _timeLabel.text = _model.time;
    _winLabel.text = [NSString stringWithFormat:@"%@  %@",_model.winDirection,_model.winPower];
    _waterlabel.text = _model.water;
    _qualityLabel.text = [NSString stringWithFormat:@"空气质量: %@",_model.quality];
    [_weatherImageView sd_setImageWithURL:[NSURL URLWithString:_model.wImageStr]];
    _waterImageView.image = [UIImage imageNamed:@"raindrop"];
    _tmpImageView.image = [UIImage imageNamed:@"map_temp"];
    _winImageView.image = [UIImage imageNamed:@"map_wind"];
    _clothesImageView.image = [UIImage imageNamed:@"windchill@2x"];
    NSString *clothes = [_model.clothes objectForKey:@"desc"];
    _clotheslabel.text = clothes;
    NSString *cool = [_model.clothes objectForKey:@"title"];
    _coollabel.text = cool;
}
@end
