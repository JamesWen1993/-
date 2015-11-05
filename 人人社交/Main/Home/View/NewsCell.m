//
//  NewsCell.m
//  SchoolYard
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "NewsCell.h"
#import "NewsModel.h"

@implementation NewsCell

- (void)setModel:(NewsModel *)model
{
    if (_model != model) {
        _model = model;
        [self _setSubViewData];
    }
}

- (void)_setSubViewData
{
    UIColor *col1 = [UIColor colorWithRed:124/255.0 green:190/255.0 blue:62/255.0 alpha:0.8];
    UIColor *col2 = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:109/255.0 alpha:0.8];
    UIColor *col3 = [UIColor colorWithRed:249/255.0 green:129/255.0 blue:199/255.0 alpha:0.8];
    UIColor *col4 = [UIColor colorWithRed:200/255.0 green:136/255.0 blue:99/255.0 alpha:0.8];
    UIColor *col5 = [UIColor colorWithRed:93/255.0 green:58/255.0 blue:151/255.0 alpha:0.8];
    NSDictionary *colorDic = @{
                               @"icon_tuding_0@2x":col1,//蓝
                               @"icon_tuding_1@2x":col2,//绿
                               @"icon_tuding_2@2x":col5,//粉
                               @"icon_tuding_3@2x":col3,//紫
                               @"icon_tuding_4@2x":col4,//红
                               @"icon_tuding_5@2x":col4,//橙
                               };

    _newsbgView.backgroundColor = [UIColor colorWithPatternImage:_model.picture];
    NSInteger a = arc4random()%6;
    NSString *string = [NSString stringWithFormat:@"icon_tuding_%li@2x",a];
    _topImageView.image = [UIImage imageNamed:string];
    _newsView.backgroundColor = [colorDic objectForKey:string];
    _titleLabel.text = _model.title;
    CGFloat fontSize = (self.bounds.size.height-95)/5;
    if(fontSize > 20)
    {
        fontSize = 20;
    }
    _titleLabel.font = [UIFont systemFontOfSize:fontSize];
    _typeLabel.text = _model.type;
    
    //获取当前时间
    NSDate *nowDate = [NSDate date];
    //日期格式化
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置日期格式
    [formatter setDateFormat:@"dd/MM/yyyy"];
    //设置时区
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *localTime = [formatter stringFromDate:nowDate];
    _dateLabel.text = localTime;
    _hotCount = arc4random()%500;
    [self _loadHot];
}

- (void)_loadHot
{
    _hotLabel.text = [NSString stringWithFormat:@"%li℃",_hotCount];
    _hotLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:10];
}
- (IBAction)downAction:(UIButton *)sender {
    _hotCount--;
    [self _loadHot];
}
- (IBAction)upAction:(UIButton *)sender {
    _hotCount++;
    [self _loadHot];
}
- (void)awakeFromNib {
    // Initialization code
}

@end
