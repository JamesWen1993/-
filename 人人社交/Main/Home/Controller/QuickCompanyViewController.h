//
//  QuickCompanyViewController.h
//  SchoolYard
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^CompanyNameBlock)(NSString *);
@interface QuickCompanyViewController : BaseViewController

@property (nonatomic, copy)NSArray *companysArray;
@property (nonatomic, copy)CompanyNameBlock block;
@property (nonatomic, copy)NSString *comName;
@end
