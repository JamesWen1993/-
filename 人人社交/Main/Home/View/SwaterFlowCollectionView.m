//
//  SwaterFlowCollectionView.m
//  SchoolYard
//
//  Created by mac on 15/10/30.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

#import "SwaterFlowCollectionView.h"
#import "NewsCell.h"
#import "UIView+UIViewController.h"
#import "NewDetailViewController.h"

static CGFloat const kMargin = 10.f;
static NSString * const reuseIdentifier = @"NewsCell";

@interface SwaterFlowCollectionView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSizeArray;

@end
@implementation SwaterFlowCollectionView

//初始化

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        if (_dataSizeArray == nil) {
            _dataSizeArray = [NSMutableArray array];
        }
        CGFloat width = (kScreenWidth - kMargin - 15)/2.f;
        for (NSUInteger idx = 0; idx < 100; idx ++) {
            CGFloat height = 150 + (arc4random() % 100);
            NSValue *value = [NSValue valueWithCGSize:CGSizeMake(width, height)];
            [_dataSizeArray addObject:value];
        }
        self.backgroundColor = [UIColor clearColor];
        //隐藏水平滑动条
        self.showsHorizontalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        //注册单元格
        UINib *nib = [UINib nibWithNibName:@"NewsCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    }
    return self;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:
                                       reuseIdentifier forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.item];
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = [[_dataSizeArray objectAtIndex:indexPath.row] CGSizeValue];
    
    return  size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //跳转详情界面
    NewDetailViewController *detail = [[NewDetailViewController alloc]init];
    detail.model = _dataArray[indexPath.item];
    [self.viewController.navigationController pushViewController:detail animated:YES];
}


@end
