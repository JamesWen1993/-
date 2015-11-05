//
//  ActivityModel.h
//  人人社交
//
//  Created by 小木木 on 15/11/2.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h>
#import "AVUser+Avatar.h"
@interface ActivityModel : BaseModel

@property (nonatomic, copy)NSString *activity_Title; //
@property (nonatomic, copy)NSString *activity_Time;
@property (nonatomic, copy)NSString *activity_SignUpFinishTime;
@property (nonatomic, copy)NSString *activity_Location;
@property (nonatomic, copy)NSString *activity_LocationDetail;
@property (nonatomic, copy)NSString *activity_Money;
@property (nonatomic, copy)NSString *activity_Detail;
@property (nonatomic, copy)NSString *objectId;

@property (nonatomic, copy)NSString *UserSchool;
@property (nonatomic, assign)BOOL UserSexView; //男女 1是男 0是女
@property (nonatomic, strong)AVFile *activity_PosterImage;
@property (nonatomic, copy)NSString *activity_peopleNum;
@property (nonatomic, copy)NSString *activity_maxPeopleNum;



@end
