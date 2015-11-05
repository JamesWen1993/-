//
//  TableViewCell.h
//  人人社交
//
//  Created by huiwenjiaoyu on 15/10/26.
//  Copyright © 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"
@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *signupLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *upImage;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong)ActivityModel *model;

@end
