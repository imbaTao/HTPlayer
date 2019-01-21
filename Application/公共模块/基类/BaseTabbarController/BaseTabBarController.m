//
//  BaseTabBarController.m
//  HZYToolBox
//
//  Created by hong  on 2018/6/26.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "BaseTabBarController.h"
@interface BaseTabBarController ()<BaseTabbarViewDelegate>
/** isDisplayTabbar */
@property(nonatomic,assign)BOOL isDisplayTabbar;
@end


#define BarHeight 49
@implementation BaseTabBarController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isDisplayTabbar = true;
        [self.tabBar removeFromSuperview];
        [self.tabBar setHidden:YES];
        self.tabBar.userInteractionEnabled = false;
        [self.view addSubview:self.customBar];
        [self.customBar mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.offset(-SAFE.bottom).priorityMedium();
            } else {
                make.bottom.offset(0).priorityMedium();
            }
            make.height.offset(BarHeight);
            make.left.offset(0);
            make.right.offset(0);
        }];
    }
    return self;
}

#pragma mark - BarViewDelegate
- (void)changeBarIndexWithIndex:(NSInteger)index{
    self.selectedIndex = index;
}

- (BaseTabbarView *)customBar{
    if (!_customBar) {
        _customBar = [[BaseTabbarView alloc] init];
        _customBar.delegate = self;
    }
    return _customBar;
}

#pragma mark - private
- (void)showTabbar{
     if (!self.isDisplayTabbar) {
         [UIView animateWithDuration:0.5 animations:^{
             [self.customBar mas_updateConstraints:^(MASConstraintMaker *make) {
                 if (@available(iOS 11.0, *)) {
                     make.bottom.offset(-SAFE.bottom).priorityMedium();
                 } else {
                     make.bottom.offset(0).priorityMedium();
                 }
             }];
             [self.view layoutIfNeeded];
         }completion:^(BOOL finished) {
             self.isDisplayTabbar = true;
         }];
     }
}

- (void)hiddeTabbar{
    if (self.isDisplayTabbar) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.customBar mas_updateConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                    make.bottom.offset(BarHeight + SAFE.bottom).priorityMedium();
                } else {
                    make.bottom.offset(BarHeight).priorityMedium();
                }
            }];
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            self.isDisplayTabbar = false;
        }];
    }
}


- (BOOL)isDisplayedInScreen{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect intersectionRect = CGRectIntersection(self.customBar.frame, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    return TRUE;
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

