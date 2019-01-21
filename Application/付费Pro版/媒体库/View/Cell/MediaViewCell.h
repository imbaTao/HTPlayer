//
//  MediaViewCell.h
//  myProgramming
//
//  Created by hong on 2017/5/3.
//  Copyright © 2017年 hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaModel.h"
#define MediaCellWidth (SCREEN_W - 8 * 4) / 3

@interface MediaViewCell : UICollectionViewCell

/** 右上角选中圈 */
@property(nonatomic,strong)UIImageView *circlImgView;


/** miedaPicView*/
@property(nonatomic,copy) UIImageView *movieIconView;

/** backGroundImgView*/
@property(nonatomic,copy) UIImageView *backGroundImgView;

/** playRecordTime */
@property(nonatomic,strong) UILabel *playRecordAndAllTimeLB;

/** titleLB */
@property(nonatomic,strong)UILabel *titleLB;

- (void)layoutPageViews;
@end
