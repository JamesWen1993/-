//
//  JKCityPickerView.h
//  CityPickerView
//
//  Created by Jakey on 14/12/22.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TouchButton)(UIBarButtonItem *barButton);
typedef void (^DoneButtonTouch)(NSString *province,NSString*city,NSDictionary*cityItem);

typedef void (^OnChangeBlock)(NSString *province,NSString*city,NSDictionary*cityItem);

@interface JKCityPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    TouchButton _leftActionBlock;
    DoneButtonTouch _rightActionBlock;
    OnChangeBlock _onChangeBlock;

    UIPickerView *_picker;
    NSArray *_provinceArray;
    NSArray *_cityArray;
    NSDictionary *_selectDic;
    NSDictionary *_cityItem;
}
@property (nonatomic, strong) NSString *provinceString;
@property (nonatomic, strong) NSString *cityString;

-(void)setLeftActionBlock:(TouchButton)actionBlock;
-(void)setRightActionBlock:(DoneButtonTouch)actionBlock;
-(void)setOnChangeBlock:(OnChangeBlock)onChangeBlock;

-(void)setDataList:(NSArray*)proviceArray;
@end
