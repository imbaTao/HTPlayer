//
//  MenuBubbleView.h
//  TinyPlayer_V1
//
//  Created by Mr.h on 2018/4/11.
//  Copyright © 2018年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BubbleCVCellDelegate <NSObject>

- (void)bubbleCellAction:(NSIndexPath *)indexPath;

@end

@interface MenuBubbleView : UIView


/** listCV */
@property(nonatomic,strong)UICollectionView *btnlistCV;


/** deledate */
@property(nonatomic,weak) id<BubbleCVCellDelegate> delegate;

@end
