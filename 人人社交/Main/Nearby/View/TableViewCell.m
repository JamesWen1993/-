//
//  TableViewCell.m
//  人人社交
//
//  Created by huiwenjiaoyu on 15/10/26.
//  Copyright © 2015年 huiwen. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TableViewCell



- (void)setModel:(ActivityModel *)model{
    if (_model != model) {
        _model = model;
    }
    //活动时间
    _timeLabel.text = _model.activity_Time;

    //活动主题
    self.titleLabel.text = _model.activity_Title;
    
    //活动地点
    self.locationLabel.text = _model.activity_Location;
    
    //报名人数
    self.peopleNumLabel.text = [NSString stringWithFormat:@"%@", _model.activity_peopleNum];
    
    //活动海报

    AVFile *posterImage = _model.activity_PosterImage;

    [self.posterView setImageWithURL:[NSURL URLWithString:posterImage.url]];

    self.schoolLabel.text = _model.activity_LocationDetail;
    //性别
//    if (model.UserSexView == 1) {
//        
//        self.sexView.image = [UIImage imageNamed:@"icon_Male@3x.png"];
//        
//    }else{
//        
//        self.sexView.image = [UIImage imageNamed:@"icon_Female@3x.png"];
//        
//    }
    
    //学校
//    self.schoolLabel.text = model.UserSchool;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
