//
//  SendViewController.h
//  人人社交
//
//  Created by huiwenjiaoyu on 15/10/26.
//  Copyright © 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ActivityModel.h"
@class  MapViewController;

typedef void(^ActivityBlock) (ActivityModel *);

@interface SendViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong)UITextField *titleText;
@property (nonatomic, strong)UITextField *timeText;
@property (nonatomic, strong)UITextField *signupFinishText;
@property (nonatomic, strong)UITextField *locationText;
@property (nonatomic, strong)UITextField *locationDetailText;
@property (nonatomic, strong)UITextField *moneyText;
@property (nonatomic, strong)UITextField *maxPeopleNum;
@property (nonatomic, strong)UITextView *activityDetailText;

@property (nonatomic, retain)MapViewController *mapView;

@property (nonatomic, copy)ActivityBlock block;

@end
