//
//  HZYBubbleVC.h
//  HZYToolBox
//
//  Created by hong  on 2018/8/28.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "BaseViewController.h"
//
//  HZYBubbleVC.h
//  TestApp
//
//  Created by hong  on 2018/8/3.
//  Copyright © 2018年 洪正烨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYBubbleHeaderView.h"
#import "HZYBubbleCell.h"

typedef NS_OPTIONS(NSInteger, BubbleTye) {
    MenuBubble = 0,
    InfomationBubble
};
@protocol HZYBubbleDelegate <NSObject>
- (void)bubbleCellSelected:(NSInteger)row type:(BubbleTye)type;
@end


@interface HZYBubbleVC : UIViewController

/** 功能列表 */
@property(nonatomic,strong)UITableView *functionTableView;

/** delegate */
@property(nonatomic,weak)id <HZYBubbleDelegate> delegate;

/** haveHeader */
@property(nonatomic,assign)BOOL haveHeader;

/** appointView */
@property(nonatomic,weak)id appointView;

/** headerView */
@property(nonatomic,strong)HZYBubbleHeaderView *headerView;


- (instancetype)initWithTitleArr:(NSArray *)titleArr picNameArr:(NSArray *)picNameArr appointView:(id)appointView width:(CGFloat)width haveHeader:(BOOL)haveHeader;

- (void)showBubbleWithVC:(UIViewController *)vc;
- (void)hideBubble;
@end
