//
//  FriendsCell.m
//  人人社交
//
//  Created by mac on 15/10/13.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "FriendsCell.h"
#import "FriendsTableView.h"

@implementation FriendsCell

- (void)awakeFromNib {
    self.imageView.image = [UIImage imageNamed:@"cat/button_icon_plus"];
    
    
}
- (void)setModel:(FriendsModel *)model {
    
    _model = model;
    _userName.text = model.friendsId;
    _userImage.clipsToBounds = YES;
    _userImage.layer.cornerRadius = 5;
    _userImage.image = [UIImage imageNamed:@"icon_myself_h@2x"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
