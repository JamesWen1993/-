//
//  UIView+UIViewController.m
//  项目二day1
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)


- (UIViewController *)viewController {
    
    //下一个响应者
    UIResponder *next = self.nextResponder;
    

    do {
        //判断响应者类型是都是视图控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
    } while (next != nil );
    
    return nil;
    
    
}

@end
