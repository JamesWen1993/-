//
//  DataPickerView.h
//  人人社交
//
//  Created by huiwenjiaoyu on 15/10/26.
//  Copyright © 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TouchButton)(UIBarButtonItem *barButton);
typedef void (^DataDoneButton)(NSString *,NSString *, NSString *, NSString *) ;

@interface DataPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>{
    TouchButton _leftActionBlock;
    DataDoneButton _rightActionBlock;
    UIPickerView *_picker;
    
    NSMutableArray *_mouthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minutesArray;
}

@property (nonatomic, assign)NSString *mouthStr;
@property (nonatomic, assign)NSString *dayStr;
@property (nonatomic, assign)NSString *hourStr;
@property (nonatomic, assign)NSString *minutesStr;


-(void)setLeftActionBlock:(TouchButton)actionBlock;
-(void)setRightActionBlock:(DataDoneButton)actionBlock;

@end
