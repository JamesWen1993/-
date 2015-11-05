//
//  NewsModel.h
//  SchoolYard
//
//  Created by mac on 15/10/30.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h>
/*
 "title": "玻璃心的人都会喜欢这些东西",
 "description": "一条",
 "picUrl": "http://zxpic.gtimg.com/infonew/0/wechat_pics_-551403.jpg/640",
 "url": "http://mp.weixin.qq.com/s?__biz=MjM5MDI5OTkyOA==&idx=1&mid=222639330&sn=b7b0425cde58aea059d9376da0d40444&qb_mtt_show_type=1"
 */
@interface NewsModel : BaseModel

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *picUrl;
@property (nonatomic, strong)UIImage *picture;

- (void)changeImageData:(NSString *)pic;


@end
