//
//  MediaEditMenuBar.h
//  敢聊播放器
//
//  Created by Mr.h on 2018/9/1.
//  Copyright © 2018年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionview.h"
@protocol MediaEditMenuBarDelegate <NSObject>
- (void)menuSeletedWithIndexRow:(NSInteger)row;
@end

#define EditCellWidth SCREEN_W / 6
#define EditCellHight 45

@interface MediaEditMenuCell : UICollectionViewCell
/** iconImgView */
@property(nonatomic,strong)UIImageView *iconImgView;
/** rightColLine */
@property(nonatomic,strong)UILabel *rightColLine;
@end

@interface MediaEditMenuModel : NSObject
/** canUse */
@property(nonatomic,assign)BOOL canUse;

/** canUseImg */
@property(nonatomic,strong)UIImage *canUseImg;

/** cantUseImg */
@property(nonatomic,strong)UIImage *cantUseImg;

/** canUse */
@property(nonatomic,assign)BOOL isSeleted;
@end

@interface MediaEditMenuBar : BaseCollectionview
/** delegate */

@property(nonatomic,weak)id <MediaEditMenuBarDelegate> cellDelegate;

- (void)showOrHiddenBar:(BOOL)order;
@end
