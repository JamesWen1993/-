//
//  CDUserFactory.m
//  LeanChatExample
//
//  Created by lzw on 15/4/7.
//  Copyright (c) 2015年 avoscloud. All rights reserved.
//

#import "CDUserFactory.h"


@implementation CDUser

@end


@implementation CDUserFactory

#pragma mark - CDUserDelegate

// cache users that will be use in getUserById
- (void)cacheUserByIds:(NSSet *)userIds block:(AVBooleanResultBlock)block {
    block(YES, nil); // don't forget it
}
//自己
- (id <CDUserModel> )getUserById:(NSString *)userId avatarUrl:(NSString *)avatarUrl {
    CDUser *user = [[CDUser alloc] init];
    user.userId = userId;
    user.username = userId;
    user.avatarUrl = avatarUrl;
    return user;
}


- (id <CDUserModel> )getUserById:(NSString *)userId {
    CDUser *user = [[CDUser alloc] init];
    user.userId = userId;
    user.username = userId;
//    user.avatarUrl = @"http://ac-x3o016bx.clouddn.com/86O7RAPx2BtTW5zgZTPGNwH9RZD5vNDtPm1YbIcu";
    user.avatarUrl = @"http://app1.showapi.com/weather/icon/night/00.png";
    return user;
}

@end
