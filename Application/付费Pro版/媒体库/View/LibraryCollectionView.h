//
//  LibraryCollectionView.h
//  TinyPlayer_V1
//
//  Created by hong on 2017/7/10.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionview.h"
#import "MediaViewCell.h"
@protocol MediaCollectionViewDelegate <NSObject>

- (void)cellselectedWithRow:(NSInteger)row isEditing:(BOOL)isEditing;

// 1是开始0是结束
- (void)checkOutMediaInfo:(BOOL)beginOrEnd indexRow:(NSInteger)row;

- (void)cellItemChangePlace;

@end

typedef NS_OPTIONS(NSInteger, ComposingType) {
    Row = 0,
    Col
};
@interface LibraryCollectionView : BaseCollectionview

/** 多列 */
@property(nonatomic,strong)UICollectionViewFlowLayout *colFlowLayout;

/** 单行 */
@property(nonatomic,strong)UICollectionViewFlowLayout *rowFlowLayout;

/** rowOrCloum */
@property(nonatomic,assign)ComposingType rowOrCol;

/** isEditing */
@property(nonatomic,assign)BOOL isEditing;

/** selectedCount */
@property(nonatomic,assign)int selectedCount;

/** delegate */
@property(nonatomic,weak) id<MediaCollectionViewDelegate> cellDelegate;

- (void)p_endEdit;
@end
