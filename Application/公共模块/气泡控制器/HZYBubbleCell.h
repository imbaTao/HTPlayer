//
//  HZYBubbleCell.h
//  TestApp
//
//  Created by hong  on 2018/8/3.
//  Copyright © 2018年 洪正烨. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CellWidth SCREEN_W * 0.3
#define CellHeight 55.0
@interface HZYBubbleCell : UITableViewCell
/** 图标 */
@property(nonatomic,strong)UIImageView *iconView;


/** 内容 */
@property(nonatomic,strong)UILabel *contentLB;

/** 分割线 */
@property(nonatomic,strong)UIImageView *segementLine;

/** 需要居左 */
@property(nonatomic,assign)BOOL textLeftSide;
@end
