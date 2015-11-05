//
//  ActivityDetailVc.h
//  人人社交
//
//  Created by huiwenjiaoyu on 15/10/28.
//  Copyright © 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "ActivityModel.h"
#import <UIKit/UIKit.h>
@interface ActivityDetailVc : BaseViewController

/*
 @property (nonatomic, strong)UITextField *titleText;
 @property (nonatomic, strong)UITextField *timeText;
 @property (nonatomic, strong)UITextField *signupFinishText;
 @property (nonatomic, strong)UITextField *locationText;
 @property (nonatomic, strong)UITextField *locationDetailText;
 @property (nonatomic, strong)UITextField *moneyText;
 @property (nonatomic, strong)UITextView *activityDetailText;

 */

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *userImage;
@property (nonatomic, strong)UILabel *nickName;

@property (nonatomic, strong)UITextView *activityDetail;

@property (nonatomic, strong)ActivityModel *model;


@end
