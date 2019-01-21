//
//  MenuBubbleView.m
//  TinyPlayer_V1
//
//  Created by Mr.h on 2018/4/11.
//  Copyright © 2018年 Great. All rights reserved.
//

#import "MenuBubbleView.h"
#import "BubbleSettingCell.h"
#import "BubbleConfigModel.h"

@interface MenuBubbleView  ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** dataArray */
@property(nonatomic,strong) NSMutableArray *dataArray;

@end

#define Arror_height 8
@implementation MenuBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GlobalBackColor;
        [self addSubview:self.btnlistCV];
        [self layoutPageViews];
    }
    return self;
}

- (void)layoutPageViews{
    [_btnlistCV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 4, Arror_height, 4));
    }];
}

#pragma mark - CollectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BubbleSettingCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    BubbleConfigModel *model  = self.dataArray[indexPath.row];
    
    cell.picV.image = [UIImage imageNamed:model.picImageName];
    
    cell.titleLb.text = model.titleName;
    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate bubbleCellAction:indexPath];
}

#pragma mark - Setter && Getter
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
#ifdef FREE
         NSArray *titleArray = @[LOCALKEY(@"Instructions"),LOCALKEY(@"Lock"),LOCALKEY(@"Buy"),LOCALKEY(@"Feedback")];
         NSArray *imageNameArr = @[@"bubble_help",@"bubble_lock",@"bubble_buy",@"bubble_advise"];
#else
         NSArray *titleArray = @[LOCALKEY(@"Instructions"),LOCALKEY(@"Lock"),LOCALKEY(@"Feedback")];
         NSArray *imageNameArr = @[@"bubble_help",@"bubble_lock",@"bubble_advise"];
#endif
        for (int i = 0; i<titleArray.count ; i++) {
            BubbleConfigModel *model  = [[BubbleConfigModel alloc]init];
            model.picImageName = imageNameArr[i];
            model.titleName = titleArray[i];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (UICollectionView *)btnlistCV{
    if (!_btnlistCV) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake((SCREEN_W * 0.8 - 8) / 3, SCREEN_W * 0.8 * 3/4 / 2);
        if (SCREEN_W > SCREEN_H) {
            flowLayout.itemSize = CGSizeMake((SCREEN_H * 0.8 - 8) / 3, SCREEN_H * 0.8 * 3/4 / 2);
        }
        
        _btnlistCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _btnlistCV.backgroundColor = GlobalBackColor;
        _btnlistCV.scrollEnabled = false;
        [_btnlistCV registerClass:[BubbleSettingCell class] forCellWithReuseIdentifier:@"cell"];
        _btnlistCV.dataSource = self;
        _btnlistCV.delegate = self;
        [_btnlistCV reloadData];
    }
    return _btnlistCV;
}





-(void)drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 2.0;
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
}

-(void)drawInContext:(CGContextRef)context {
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, GlobalBackColor.CGColor);
    [self drawPath:context withX:self.bounds.size.width - 20];
    CGContextFillPath(context);
    //    CGContextRelease(context);
}

- (void)drawPath:(CGContextRef)context withX:(CGFloat)x{
    CGRect rect = self.bounds;
    CGFloat minX = CGRectGetMinX(rect),
    maxX = CGRectGetMaxX(rect),
    minY = CGRectGetMinY(rect),
    maxY = CGRectGetMaxY(rect);
    
    CGFloat beginX = x;
    CGFloat xOffset = 10;
    CGFloat beginY = rect.size.height - Arror_height;
    CGFloat arrowH = 10;
    CGFloat radius = 8.0;
    
    CGContextMoveToPoint(context, beginX + xOffset, beginY);
    CGContextAddArcToPoint(context, beginX, maxY, beginX - xOffset, beginY, 4);
    CGContextAddLineToPoint(context, beginX - xOffset, beginY);
    
    
    CGContextAddArcToPoint(context, minX, beginY, minX, minY, radius);
    CGContextAddArcToPoint(context, minX, minY, maxX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, maxY, radius);
    CGContextAddArcToPoint(context, maxX, beginY, beginX + xOffset,beginY,radius);
    CGContextClosePath(context);
}




@end
