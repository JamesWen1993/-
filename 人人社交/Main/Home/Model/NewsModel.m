//
//  NewsModel.m
//  SchoolYard
//
//  Created by mac on 15/10/30.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "NewsModel.h"
@implementation NewsModel

- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *att = @{
                          @"title":@"title",
                          @"type":@"description",
                          @"picUrl":@"picUrl",
                          @"url":@"url"
                          };
    return att;
}

- (void)changeImageData:(NSString *)pic {
    
    NSURL *url = [NSURL URLWithString:pic];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        //下载图片数据任务在多线程中处理
        NSData * data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        //更新UI要在主线程中处理
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_picture != image) {
                _picture = image;
            }
            
        });

    });

}
@end
