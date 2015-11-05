//
//  CityPickerView.m
//  CityPickerView
//
//  Created by Jakey on 14/12/22.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//
#define ProvinceComponent 0
#define CityComponent 1

#import "JKCityPickerView.h"

@implementation JKCityPickerView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self buildViews:frame];
    }
    return self;
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
-(void)setDataList:(NSArray*)proviceArray{
    _provinceArray = [proviceArray copy];
    _selectDic = [proviceArray objectAtIndex:0];
    self.provinceString =[_selectDic objectForKey:@"privinceName"];

    if (_selectDic != nil) {
       _cityArray = [_selectDic objectForKey:@"citys"];
        self.cityString =[_cityArray[0] objectForKey:@"cityName"];
        _cityItem = _cityArray[0];
    }
    
}
#pragma -mark - buttom blcok
-(void)setLeftActionBlock:(TouchButton)actionBlock{
    if (actionBlock) {
        _leftActionBlock = actionBlock;
    }
}
-(void)setRightActionBlock:(DoneButtonTouch)actionBlock{
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
        _rightActionBlock(self.provinceString,self.cityString,_cityItem);
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)setOnChangeBlock:(OnChangeBlock)onChangeBlock{
    if (onChangeBlock) {
        _onChangeBlock = onChangeBlock;
    }
}
#pragma -mark - picker view delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case ProvinceComponent:
        {
            return [_provinceArray count];
        }
            break;
        case CityComponent:
        {
            return [_cityArray count];
        }
            break;
        default:
            break;
    }
    return 0;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case ProvinceComponent:
        {
            return [_provinceArray[row] objectForKey:@"privinceName"];
        }
            break;
        case CityComponent:
        {
            return [_cityArray[row] objectForKey:@"cityName"];
        }
            break;
            
        default:
            break;
    }
    return nil;
}

//获取滚轮标题
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == ProvinceComponent) {
        self.provinceString = [_provinceArray[row] objectForKey:@"privinceName"];
        _selectDic =_provinceArray[row];
        
        if (_selectDic != nil) {
            _cityArray = [_selectDic objectForKey:@"citys"];
        } else {
            _cityArray = nil;
        }
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        self.cityString =[_cityArray[0] objectForKey:@"cityName"];
        _cityItem = _cityArray[0];

    }
    
    if (component == CityComponent) {
        self.cityString = [_cityArray[row] objectForKey:@"cityName"];
        _cityItem = _cityArray[0];
    }
    if (_onChangeBlock) {
        _onChangeBlock(self.provinceString,self.cityString,_cityItem);
    }
    NSLog(@"provinceString:%@,cityString:%@",self.provinceString,self.cityString);
}
@end
