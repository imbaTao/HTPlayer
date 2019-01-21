//
//  VolumeAndBrightHUDView.m
//  TestApp
//
//  Created by hong  on 2018/1/9.
//  Copyright © 2018年 洪正烨. All rights reserved.
//

#import "VolumeAndBrightHUDView.h"


@interface VolumeAndBrightHUDView()

@end


@implementation VolumeAndBrightHUDView


- (void)layoutSubviews{
    [self p_configUI];
}

#pragma mark - Private
- (void)p_configUI{
    // 自身倒角
//    self.layer.masksToBounds = true;
//    self.layer.cornerRadius = 14;
    
    _grayBackView.layer.masksToBounds = true;
    _grayBackView.layer.cornerRadius = 1.5;
   
//    _configValueView.layer.masksToBounds = true;
//    _configValueView.layer.cornerRadius = 1.5;
//    _configValueView.layer.shadowOffset = CGSizeMake(0, -3);
//    _configValueView.layer.shadowOpacity = 0.2;
//    _configValueView.layer.shadowRadius = 2;
}

@end
