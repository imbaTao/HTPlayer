//
//  MediaEditMenuBar.m
//  敢聊播放器
//
//  Created by Mr.h on 2018/9/1.
//  Copyright © 2018年 Great. All rights reserved.
//

#import "MediaEditMenuBar.h"
@implementation MediaEditMenuModel
@end


@implementation MediaEditMenuCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.rightColLine];
        [self layoutPageViews];
    }
    return self;
}

- (void)layoutPageViews{
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.rightColLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, 18));
    }];
}

#pragma mark - Setter && Getter
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)rightColLine{
    if (!_rightColLine) {
        _rightColLine = [[UILabel alloc] init];
        _rightColLine.backgroundColor = [UIColor whiteColor];
        _rightColLine.hidden = true;
    }
    return _rightColLine;
}
@end

@implementation MediaEditMenuBar
@synthesize dataArray = _dataArray;
- (instancetype)initWithLayout:(UICollectionViewFlowLayout *)layout cellClass:(id)class identifier:(NSString *)identifier{
    self = [super initWithLayout:layout cellClass:class identifier:identifier];
    if (self) {
        self.alpha = 0;
    }
    return self;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MediaEditMenuModel *model = self.dataArray[indexPath.row];
    if (indexPath.row == 0 || indexPath.row == self.dataArray.count - 1) {
        model.canUse = true;
    }
    MediaEditMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellID forIndexPath:indexPath];
    if (indexPath.row != 0) {
        cell.iconImgView.image = model.canUse ? model.canUseImg : model.cantUseImg;
        cell.userInteractionEnabled = model.canUse;
    }else{
        cell.iconImgView.image = model.isSeleted ? model.canUseImg : model.cantUseImg;
        cell.userInteractionEnabled = true;
    }
    
    
    
    if (indexPath.row != self.dataArray.count - 1) {
        cell.rightColLine.hidden = false;
    }else{
        cell.rightColLine.hidden = true;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.row) {
        MediaEditMenuModel *model = self.dataArray[indexPath.row];
        model.isSeleted = !model.isSeleted;
        [self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    }
    
    [self.cellDelegate menuSeletedWithIndexRow:indexPath.row];
}

#pragma mark - Setter && Getter
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *canUseNameArr = @[@"Bubble_SelectAll",@"Bubble_Top",@"Bubble_Play",@"Bubble_Rename",@"Bubble_Delete",@"Bubble_EditComple"];
        NSArray *cantUseNameArr = @[@"Bubble_UnselectAll",@"Bubble_CantTop",@"Bubble_CantPlay",@"Bubble_CantRename",@"Bubble_CantDelete",@"Bubble_EditComple"];
        for (int i = 0; i < canUseNameArr.count; i++) {
            MediaEditMenuModel *model = [[MediaEditMenuModel alloc] init];
            model.canUseImg = [UIImage imageNamed:canUseNameArr[i]];
            model.cantUseImg = [UIImage imageNamed:cantUseNameArr[i]];
            [_dataArray addObject:model];
            if (i == canUseNameArr.count - 1  || i == 0) {
                model.canUse =  true;
            }
        }
    }
    return _dataArray;
}

#pragma mark - private
- (void)showOrHiddenBar:(BOOL)order{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = order;
    }completion:^(BOOL finished) {
      if (!order) {
        for (int i = 0; i < self.dataArray.count; i++) {
            MediaEditMenuModel *model = self.dataArray[i];
            model.canUse = false;
            model.isSeleted = false;
            if (i == self.dataArray.count - 1 || i == 0) {
                model.canUse =  true;
             }
          }
          [self reloadData];
       }
    }];
}
@end
