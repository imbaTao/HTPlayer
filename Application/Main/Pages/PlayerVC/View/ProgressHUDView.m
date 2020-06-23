//
//  ProgressHUDView.m
//  TestApp
//
//  Created by hong  on 2018/1/10.
//  Copyright © 2018年 洪正烨. All rights reserved.
//

#import "ProgressHUDView.h"

@interface ProgressHUDView()


@property (weak, nonatomic) IBOutlet UIView *backMainView;


@end

@implementation ProgressHUDView

- (void)layoutSubviews{
    [super layoutSubviews];
    [self p_configUI];
}

#pragma mark - Private
- (void)p_configUI{
    // 自身倒角
    _backMainView.layer.masksToBounds = true;
    _backMainView.layer.cornerRadius = 15;
    
    
    _backProgessView.layer.masksToBounds = true;
    _backProgessView.layer.cornerRadius = 1.5;
    _playedProgressView.layer.cornerRadius = 1.5;
    _playedProgressView.layer.shadowOffset = CGSizeMake(3, 0);
    _playedProgressView.layer.shadowOpacity = 1;
    _playedProgressView.layer.shadowRadius = 3;
}


@end
