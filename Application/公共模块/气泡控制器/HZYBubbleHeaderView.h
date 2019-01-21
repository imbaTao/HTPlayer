//
//  HZYBubbleHeaderView.h
//  HZYToolBox
//
//  Created by hong  on 2018/8/31.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZYBubbleHeaderView : UIView
/** iconImgView */
@property(nonatomic,strong)UIImageView *iconImgView;

/** titleLB */
@property(nonatomic,strong)UILabel *titleLB;

/** playTimeLB */
@property(nonatomic,strong)UILabel *playTimeLB;

/** shortLine */
@property(nonatomic,strong)UILabel *shortLine;

/** ratioLB */
@property(nonatomic,strong)UILabel *ratioLB;

/** fileSizeLB */
@property(nonatomic,strong)UILabel *fileSizeLB;

/** segementLine */
@property(nonatomic,strong)UIImageView *segementLine;

@end
