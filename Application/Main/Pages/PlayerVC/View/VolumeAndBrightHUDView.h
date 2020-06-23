//
//  VolumeAndBrightHUDView.h
//  TestApp
//
//  Created by hong  on 2018/1/9.
//  Copyright © 2018年 洪正烨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeAndBrightHUDView : UIView

@property (weak, nonatomic) IBOutlet UIView *configValueView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIView *grayBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueViewConstraint;


@end
