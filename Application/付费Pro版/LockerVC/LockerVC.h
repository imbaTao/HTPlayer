//
//  LockerVC.h
//  TinyPlayer_V1
//
//  Created by Buddy.H on 2017/7/23.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void (^lockBlock)(void);
typedef void (^lockSettingComplete)(BOOL isOpen);
@interface LockerVC : BaseViewController

/** backBtn */
@property(nonatomic,strong)UIButton *backButton;

@property(nonatomic,copy)lockBlock lockBlock;

@property(nonatomic,copy)lockSettingComplete completeBlock;

/** fromAppDelegate */
@property(nonatomic,assign)bool fromAppDelegate;

@end
