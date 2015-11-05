//
//  FriendsTableView.m
//  人人社交
//
//  Created by mac on 15/10/13.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "FriendsTableView.h"
#import "FriendsCell.h"
#import "FriendsModel.h"
#import "UIView+UIViewController.h"
#import "LCEChatRoomVC.h"
#import "UIImageView+WebCache.h"


@implementation FriendsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithWhite:.5 alpha:.1];
        
        UINib *nib = [UINib nibWithNibName:@"FriendsCell" bundle:nil];
        
        [self registerNib:nib forCellReuseIdentifier:@"friendsCell"];
        
    }
    return self;
}


// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    

    return [_userSectionArray.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray* aItems = [self.userSectionArray.setionItems objectAtIndex:section];
    return aItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell" forIndexPath:indexPath];
    
    if (self.userSectionArray.setionItems.count > indexPath.section) {
        NSArray* aItems = [self.userSectionArray.setionItems objectAtIndex:indexPath.section];
        if (aItems.count > indexPath.row) {
            User *user = [aItems objectAtIndex:indexPath.row];
            FriendsModel *model = _friendsDataArray[indexPath.row];
            cell.model = model;
            cell.userName.text = user.name;
            [cell.userImage sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_myself@3x"]];

        }
    }
    
    return cell;
}

#pragma mark - 单元格组头视图
// 设定高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.userSectionArray.sectionTitles.count > section) {
        return [self.userSectionArray.sectionTitles objectAtIndex:section];
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.userSectionArray.setionItems.count > indexPath.section) {
        NSArray* aItems = [self.userSectionArray.setionItems objectAtIndex:indexPath.section];
        if (aItems.count > indexPath.row) {
            User *user = [aItems objectAtIndex:indexPath.row];

            NSString *otherId = user.name;
            
            WEAKSELF
            [[CDChatManager manager] fetchConvWithOtherId:otherId callback:^(AVIMConversation *conversation, NSError *error) {
                if (error) {
                    DLog(@"%@", error);
                }
                else {
                    LCEChatRoomVC *chatVc = [[LCEChatRoomVC alloc]initWithConv:conversation];
                    chatVc.title = otherId;
                    chatVc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.viewController.navigationController pushViewController:chatVc animated:YES];
                }
            }];
            
        }
    }
}





@end
