//
//  NewsCell.h
//  SchoolYard
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsModel;
@interface NewsCell : UICollectionViewCell

@property (nonatomic, strong)NewsModel *model;
@property (weak, nonatomic) IBOutlet UIView *newsbgView;
@property (weak, nonatomic) IBOutlet UIView *newsView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;
@property (nonatomic, assign)NSInteger hotCount;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@end
