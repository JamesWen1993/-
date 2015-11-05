//
//  NearbyViewController.h
//  人人社交
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"

@interface NearbyViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)NSInteger activityCount;

@end
