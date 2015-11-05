//
//  FriendsModel.h
//  人人社交
//
//  Created by mac on 15/10/13.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseModel.h"

@interface FriendsModel : BaseModel

//每个好友的名称

@property(nonatomic,copy)NSString *friendsId;

//每个好友的头像

@property(nonatomic,copy)NSString *icon;

@property (nonatomic, strong) NSArray *friendsDataArray;

//每个好友的个性签名

//@property(nonatomic,copy)NSString *intro;
//
//- (instancetype)initWithDict:(NSDictionary *)dict;
//+ (instancetype)friendsWithDict:(NSDictionary *)dict;
@end
