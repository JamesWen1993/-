//
//  WeekWeatherCell.h
//  SchoolYard
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"

@interface WeekWeatherCell : UICollectionViewCell

@property (nonatomic, strong)WeatherModel *model;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *tmpLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@end
