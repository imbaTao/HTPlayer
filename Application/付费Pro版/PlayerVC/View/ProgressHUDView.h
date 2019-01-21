//
//  ProgressHUDView.h
//  TestApp
//
//  Created by hong  on 2018/1/10.
//  Copyright © 2018年 洪正烨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHUDView : UIView

@property (weak, nonatomic) IBOutlet UIView *playedProgressView;

@property (weak, nonatomic) IBOutlet UIView *backProgessView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueViewConstraint;

@property (weak, nonatomic) IBOutlet UILabel *progressTimeLB;

@end
