//
//  LibraryCollectionView.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/7/10.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "LibraryCollectionView.h"
#import "MediaViewCell.h"
#import "DBHelper.h"
#import "MediaEditMenuBar.h"
#import "PlayerVC.h"
#import "HZYBubbleCell.h"
#import "VLCMediaThumbnailer+extension.h"
#import "UIImage+extension.h"
#import "MediaTool.h"

@interface LibraryCollectionView() <VLCMediaThumbnailerDelegate,UISearchBarDelegate>
/** 移动过cell */
@property(nonatomic,assign)BOOL movedCell;

/** maxThubnailCount */
@property(nonatomic,assign)NSInteger maxThubnailCount;

@end


/** path */
#define oldLibraryPath @"MediaModel/oldLibray.hzy"
#define GLOBALTEXTCOLOR RGB(181, 181, 181, 1)
@class PlayerVC;



@implementation LibraryCollectionView
- (instancetype)initWithLayout:(UICollectionViewFlowLayout *)layout cellClass:(id)class identifier:(NSString *)identifier{
    self = [super initWithLayout:layout cellClass:class identifier:identifier];
    if (self) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint point = [longPress locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    //根据长按手势的状态进行处理。
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            //当没有点击到cell的时候不进行处理
            if (!indexPath) {
                break;
            }
            if (!_isEditing) {
                [self.cellDelegate checkOutMediaInfo:true indexRow:indexPath.row];return;
            }
            //开始移动
            [self beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程中更新位置坐标
            [self updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:
            if (!_isEditing) {
                return;
            }
            //停止移动调用此方法
            [self endInteractiveMovement];
            break;
        default:
            //取消移动
            [self cancelInteractiveMovement];
            break;
        }
}


#pragma mark - CollectionViewDelegate
//- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (Arrange) {
//        return CGSizeMake(MediaCellWidth, MediaCellWidth * 1.3333 + 25);
//    }else{
//        return CGSizeMake(SCREEN_H, 100);
//    }
//}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath{
    MediaModel  *sourceModel = self.dataArray[sourceIndexPath.row];
    [self.dataArray removeObject:sourceModel];
    [self.dataArray insertObject:sourceModel atIndex:destinationIndexPath.row];
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
//        weakSelf.movedCell = true;
        int i = 1;
        for (MediaModel *model in self.dataArray) {
            model.rankNumber = i;
            i++;
        }
        [DBHelper updateMediaDataWithMediaName:weakSelf.dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self.movedCell) {
                [UIView animateWithDuration:0 animations:^{
                    [collectionView performBatchUpdates:^{
                        [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
                        self.movedCell = false;
                    } completion:nil];
                }];
//            }
        });
    });
}

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//
////    [self reloadData];
//}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MediaModel *model = self.dataArray[indexPath.row];
    MediaViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellID forIndexPath:indexPath];
    if (model.needArrange) {
        [cell layoutPageViews];
        model.needArrange = false;
    }
    if (_isEditing) {
        cell.circlImgView.hidden = false;
        cell.circlImgView.image = model.isSeleted ?  [UIImage imageNamed:@"MediaLibaray_Selected"]:[UIImage imageNamed:@"MediaLibaray_Unselected"];
    }else{
        cell.circlImgView.hidden = true;
    }
    
    cell.titleLB.text = [NSString stringWithFormat:@"%ld.%@",model.rankNumber,model.mediaName];
    if (!Arrange) {// 横向排布
        cell.playRecordAndAllTimeLB.text = [NSString stringWithFormat:@"%@ / %@ | %@",model.recordPlayTime,model.allPlayTime,model.mediaSize];
    }
    cell.movieIconView.image = model.thumbnail;
    if (cell.movieIconView.image == nil) {
        [self beginFetchWithModel:model];
    }
    return cell;
}

- (void)beginFetchWithModel:(MediaModel *)model{
    if (_maxThubnailCount < 5 && !model.isFetching) {
        VLCMediaThumbnailer *thumbnailer = [VLCMediaThumbnailer thumbnailerWithMedia:model.media andDelegate:self];
        [thumbnailer fetchThumbnail];
        model.isFetching = true;
        _maxThubnailCount++;
    }
}
#pragma mark - 缩略图代理
//[_mediaplayer saveVideoSnapshotAt:(NSString *)path withWidth:(int)width andHeight:(int)height];
- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail{
    for (MediaModel *model in self.dataArray) {
        if ([model.media isEqual:mediaThumbnailer.media]) {
            model.thumbnail =  [UIImage clipImage: [UIImage imageWithCGImage:thumbnail] toRect: CGSizeMake(MediaCellWidth, MediaCellWidth * 1.3333)];
            [self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.rankNumber - 1 inSection:0]]];
            [DBHelper updateMediaDataWithMediaName:[NSMutableArray arrayWithObject:model]];
            if (model.rankNumber < self.dataArray.count) {
                [self beginFetchWithModel:self.dataArray[model.rankNumber]];
            }
            break;
        }
    }
     _maxThubnailCount--;
}

- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer{
    for (MediaModel *model in self.dataArray) {
        if ([model.media isEqual:mediaThumbnailer.media]) {
            model.isFetching = false;
            break;
        }
    }
    _maxThubnailCount--;
}

#pragma mark - collectionViewDelgate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isEditing) {
        MediaModel *model = self.dataArray[indexPath.row];
        model.isSeleted = !model.isSeleted;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        if (model.isSeleted) {
            _selectedCount++;
        }else{
            _selectedCount--;
        }
        [self.cellDelegate cellselectedWithRow:indexPath.row isEditing:true];
    }else{
        [self.cellDelegate cellselectedWithRow:indexPath.row isEditing:false];
    }
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

#pragma mark - Setter && Getter
- (void)setIsEditing:(BOOL)isEditing{
       _isEditing = isEditing;
    [UIView animateWithDuration:0 animations:^{
        [self performBatchUpdates:^{
            [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:nil];
    }];
}


#pragma mark - Setter && Getter
- (UICollectionViewFlowLayout *)rowFlowLayout{
    if (!_rowFlowLayout) {
        _rowFlowLayout =  [[UICollectionViewFlowLayout alloc] init];
        _rowFlowLayout.minimumLineSpacing = 8;
        _rowFlowLayout.minimumInteritemSpacing = 8;
        _rowFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _rowFlowLayout.itemSize = CGSizeMake(MediaCellWidth, MediaCellWidth * 1.3333 + 25);
    }
    return _rowFlowLayout;
}

- (UICollectionViewFlowLayout *)colFlowLayout{
    if (!_colFlowLayout) {
        _colFlowLayout =  [[UICollectionViewFlowLayout alloc] init];
        _colFlowLayout.minimumLineSpacing = 8;
        _colFlowLayout.minimumInteritemSpacing = 8;
        _colFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _colFlowLayout.itemSize = CGSizeMake(SCREEN_W, 100);
    }
    return _colFlowLayout;
}

- (void)setRowOrCol:(ComposingType)rowOrCol{
    _rowOrCol = rowOrCol;
    __weak typeof(self)weakSelf = self;
    [weakSelf.dataArray enumerateObjectsUsingBlock:^(MediaModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.needArrange = true;
        model.thumbnail = nil;
    }];
    if (rowOrCol == Row) {
        [self setCollectionViewLayout:self.rowFlowLayout animated:YES completion:^(BOOL finished) {
            Arrange = false;
            [weakSelf reloadData];
        }];
    }else{
        [self setCollectionViewLayout:self.colFlowLayout animated:YES completion:^(BOOL finished) {
            Arrange = true;
             [weakSelf reloadData];
        }];
    }
}

#pragma mark - private
- (void)p_endEdit{
    for (MediaModel *model in self.dataArray) {
        model.isSeleted = false;
    }
    _selectedCount = 0;
    self.isEditing = false;
}

@end
