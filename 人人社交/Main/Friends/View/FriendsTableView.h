//
//  FriendsTableView.h
//  人人社交
//
//  Created by mac on 15/10/13.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsModel.h"
#import "User.h"
#import "UserTableSection.h"

@interface FriendsTableView : UITableView<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_data;
    BOOL _isshow[100];
    NSMutableArray *_abcArray;
    

}
@property (nonatomic, retain) UserTableSection* userSectionArray;

@property (nonatomic, strong)NSArray *friendsDataArray;//好友
@end
