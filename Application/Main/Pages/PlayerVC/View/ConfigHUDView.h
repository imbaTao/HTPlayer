//
//  ConfigHUDView.h
//  TestApp
//
//  Created by hong  on 2018/1/15.
//  Copyright © 2018年 洪正烨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigHUDView : UIView

@property (weak, nonatomic) IBOutlet UILabel *RateLB;

@property (weak, nonatomic) IBOutlet UILabel *SubTitleLB;

@property (weak, nonatomic) IBOutlet UILabel *PlaySpeedLB;

- (void)resetAllBtn;

@end
