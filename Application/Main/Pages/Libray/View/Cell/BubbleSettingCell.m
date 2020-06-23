//
//  BubbleSettingCell.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/7/12.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "BubbleSettingCell.h"
#import "UILabel+extension.h"
@implementation BubbleSettingCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addSubview:self.picV];
        [self addSubview:self.titleLb];
        
        
        
        
        [self layoutPageViews];
    }
    return self;
}





- (void)layoutPageViews{
    
    [_picV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(_picV.mas_bottom).offset(8);
    }];
    
    
}






- (UIImageView *)picV{
    if (!_picV) {
        _picV = [[UIImageView alloc] init];
    }
    return _picV;
}


- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel creatCustomeLable:11 color:[UIColor whiteColor]];
    }
    return _titleLb;
}

@end
