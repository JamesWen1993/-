//
//  FriendsCell.h
//  人人社交
//
//  Created by mac on 15/10/13.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsModel.h"

@interface FriendsCell : UITableViewCell
{
    NSArray *_data;
}
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;


@property (nonatomic, strong)FriendsModel *model;

@end
