//
//  BaseTabBarController.h
//  HZYToolBox
//
//  Created by hong  on 2018/6/26.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabbarView.h"

@interface BaseTabBarController : UITabBarController
/** tabbarView */
@property(nonatomic,strong)BaseTabbarView *customBar;
- (void)isHaveBar:(BOOL)result;
- (void)showTabbar;
- (void)hiddeTabbar;
@end
