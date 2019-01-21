//
//  MediaLibraryVC_Free.m
//  WhatsPlayer
//
//  Created by Mr.h on 11/26/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import "MediaLibraryVC_Free.h"
#import "Tabbar_Free.h"
@interface MediaLibraryVC_Free ()<HTAdToolDelgate>

@end

@implementation MediaLibraryVC_Free
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [HTAdTool loadBanner];
//    // 替换tabbar
//    HZYTabbarController *soucreBarVC = (HZYTabbarController *)self.navigationController.tabBarController;
//    [soucreBarVC.customBar removeFromSuperview];
//    soucreBarVC.customBar = nil;
//    soucreBarVC.customBar = [Tabbar_Free share];
//    soucreBarVC.customBar.delegate = soucreBarVC;
//    [soucreBarVC.view addSubview:soucreBarVC.customBar];
//    [soucreBarVC.customBar mas_remakeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.bottom.offset(-SAFE.bottom).priorityMedium();
//        } else {
//            make.bottom.offset(0).priorityMedium();
//        }
//        make.left.offset(0);
//        make.right.offset(0);
//        make.height.offset(NOAD ? 49 : 50);
//    }];
//    BANNER.rootViewController = self;
//    [HTAdTool share].delegate = self;
//}
//
////
//- (void)AdLoadedSuccessful{
//    NSLog(@"%d",BANNER.adSize.size.height);
//    // 更改高度
//    HZYTabbarController *soucreBarVC = (HZYTabbarController *)self.navigationController.tabBarController;
//    [soucreBarVC.customBar mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(SCREEN_W);
//        make.left.offset(0);
//        make.bottom.offset(0);
//        make.height.offset(99);
//    }];
//}
//
//

//- (void)removeAdComplete{
//
//}

@end
