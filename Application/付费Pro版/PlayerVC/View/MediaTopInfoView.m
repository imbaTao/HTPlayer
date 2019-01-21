//
//  MediaTopInfoView.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/6/10.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "MediaTopInfoView.h"
#import "UIButton+extension.h"

@interface MediaTopInfoView()

/** backBtn */
@property(nonatomic,strong) UIButton  *backButton;

@end

@implementation MediaTopInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.56];
        [self addSubview:self.backButton];
        [self addSubview:self.mediaNameLB];
        [self layoutPageViews];
    }
    return self;
}

- (void)layoutPageViews{
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.offset(10);
    }];
 
    [_mediaNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backButton.mas_right).offset(20);
        make.right.offset(-60);
        make.centerY.equalTo(self);
    }];
}


#pragma mark - reponseActive
- (void)buttonClick{
//    self.backBlock();
}

#pragma mark - setter&getter
- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton creatBtnMethodWithColor:nil Image:@"back" title:@"" VC:self selecter:@selector(buttonClick)];
        
    }
    return _backButton;
}


- (UILabel *)mediaNameLB{
    if (!_mediaNameLB) {
        _mediaNameLB = [[UILabel alloc] init];
        _mediaNameLB.font = FONT_SIZE(13);
        _mediaNameLB.textColor = [UIColor whiteColor];
        _mediaNameLB.lineBreakMode = NSLineBreakByTruncatingTail;
        _mediaNameLB.textAlignment = NSTextAlignmentCenter;
    }
    return _mediaNameLB;
}

@end
