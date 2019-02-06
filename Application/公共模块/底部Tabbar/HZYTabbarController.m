//
//  HZYTabbarController.m
//  HZYToolBox
//
//  Created by hong  on 2018/6/27.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "HZYTabbarController.h"
#import "BaseNavigationController.h"

#import "MediaLibraryVC.h"
#import "LinkViewController.h"
#import "SettingViewController.h"

#ifndef ISPRO
#import "MediaLibraryVC_Free.h"
#import "SettingViewController_Free.h"
#import "WhatsPlayer-Swift.h"
#endif
@interface HZYTabbarController ()

@end


@implementation HZYTabbarController

static HZYTabbarController *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    _instance = [super allocWithZone:zone];
    });
return _instance;
}

+(instancetype)share
{
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone
{
return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
return _instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_initSubVC];
    }
    return self;
}


#pragma mark - private
- (void)p_initSubVC{
#ifdef ISPRO
    MediaLibraryVC *vc1 = [[MediaLibraryVC alloc] init];
     SettingViewController *vc3 = [[SettingViewController alloc] init];
#else
    MediaLibray_ViewController *vc1 = [[MediaLibray_ViewController alloc] init];
    SettingViewController_Free *vc3 = [[SettingViewController_Free alloc] init];
#endif
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:vc1];
    LinkViewController *vc2 = [[LinkViewController alloc] init];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:vc2];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:vc3];
    NSArray *subVCArr = @[nav1,nav2,nav3];
    for (int i = 0; i < subVCArr.count; i++) {
        [self addChildViewController:subVCArr[i]];
    }
}

- (BOOL)shouldAutorotate{
    [super shouldAutorotate];
    return self.selectedViewController.shouldAutorotate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
