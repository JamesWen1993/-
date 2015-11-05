//
//  DataPickerView.m
//  人人社交
//
//  Created by huiwenjiaoyu on 15/10/26.
//  Copyright © 2015年 huiwen. All rights reserved.
//

#define MouthComponent 0
#define DayComponent 1
#define HourComponent 2
#define MinutesComponent 3

#import "DataPickerView.h"

@implementation DataPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mouthArray = [[NSMutableArray alloc] init];
        _dayArray = [[NSMutableArray alloc] init];
        _hourArray = [[NSMutableArray alloc] init];
        _minutesArray = [[NSMutableArray alloc] init];
        _mouthStr = @"1月";
        _dayStr = @"1日";
        _hourStr = @"00";
        _minutesStr = @"00";
        [self _loadData];
        [self buildViews:frame];
    }
    return self;
}

- (void)_loadData{
    
    for (int i = 0; i < 60; i++) {
        NSString *str = [NSString stringWithFormat:@"%i",i];
        
        if (i >= 1 && i <= 12) {
            
            [_mouthArray addObject:[NSString stringWithFormat:@"%@月",str]]; //月
            
        }
        if (i <= 31 && i >= 1) {
            
            [_dayArray addObject:[NSString stringWithFormat:@"%@日",str]]; //日
            
        }
        if (i < 24){
            
            if (i < 10) {
                [_hourArray addObject:[NSString stringWithFormat:@"0%@",str]];
            }else{
                [_hourArray addObject:str]; //时
            }
        }
        if (i < 10) {
            [_minutesArray addObject:[NSString stringWithFormat:@"0%@",str]];
        }else{
            [_minutesArray addObject:str]; //分
        }
    }

}


-(void)buildViews:(CGRect)frame{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                 target:self action:@selector(leftClick:)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                  target:self action:@selector(rightClick:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    
    NSArray*buttons=[NSArray arrayWithObjects:leftItem, space, rightItem, nil];
    
    
    //为子视图构造工具栏
    UIToolbar *toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,frame.size.width, 44)];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar setItems:buttons animated:YES];
    [self addSubview:toolbar];
    
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, toolbar.frame.size.height, frame.size.width, frame.size.height-toolbar.frame.size.height)];
    [self addSubview:_picker];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    
    
}

#pragma -mark - buttom blcok
-(void)setLeftActionBlock:(TouchButton)actionBlock{
    if (actionBlock) {
        _leftActionBlock = actionBlock;
    }
}
-(void)setRightActionBlock:(DataDoneButton)actionBlock{
    if (actionBlock) {
        _rightActionBlock  = actionBlock;
    }
}

-(void)leftClick:(UIBarButtonItem*)item{
    if (_leftActionBlock) {
        _leftActionBlock(item);
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)rightClick:(UIBarButtonItem*)item{
    if (_rightActionBlock) {
        _rightActionBlock(self.mouthStr,self.dayStr,self.hourStr,self.minutesStr);
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - pickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case MouthComponent:
            return _mouthArray.count;
            break;
        case DayComponent:
            return _dayArray.count;
            break;
        case HourComponent:
            return _hourArray.count;
            break;
        case MinutesComponent:
            return _minutesArray.count;
            break;
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case MouthComponent:
            return _mouthArray[row];
            break;
        case DayComponent:
            return _dayArray[row];
            break;
        case HourComponent:
            return _hourArray[row];
            break;
        case MinutesComponent:
            return _minutesArray[row];
            break;
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case MouthComponent:
            self.mouthStr = _mouthArray[row];
            break;
        case DayComponent:
            self.dayStr = _dayArray[row];
            break;
        case HourComponent:
            self.hourStr = _hourArray[row];
            break;
        case MinutesComponent:
            self.minutesStr = _minutesArray[row];
            break;
    }
    if (_rightActionBlock) {
        _rightActionBlock(self.mouthStr,self.dayStr,self.hourStr,self.minutesStr);
    }
}
@end
