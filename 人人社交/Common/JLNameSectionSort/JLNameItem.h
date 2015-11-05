//
//  JLNameItem.m
//  JLNameSectionSort
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface JLNameItem : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* sortString;// 供排序所用字串
@property (nonatomic) unichar firstLetter;// 首字母
@property (nonatomic, copy) NSString* avatarUrl;

- (NSString* )createSortString;

@end
