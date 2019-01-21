//
//  HZYBubbleHeaderView.m
//  HZYToolBox
//
//  Created by hong  on 2018/8/31.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "HZYBubbleHeaderView.h"
#import "UIImage+extension.h"
#import "HZYBubbleCell.h"
#define TitleFontSize 12
#define SubTitleFontSize 10
@implementation HZYBubbleHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLB];
        [self addSubview:self.playTimeLB];
        //        [self addSubview:self.ratioLB];
        //        [self addSubview:self.fileSizeLB];
        [self addSubview:self.segementLine];
        [self layoutPageViews];
    }
    return self;
}

- (void)layoutPageViews{
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        if (IS_PAD) {
             make.size.mas_equalTo(CGSizeMake(60, 60)).priorityHigh();
        }else{
             make.size.mas_equalTo(CGSizeMake(30, 30)).priorityHigh();
        }
        make.left.offset(10);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_top).offset(-2);
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(8).priorityHigh();
        make.right.offset(-10);
    }];
    
    [self.playTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconImgView.mas_bottom);
        make.left.equalTo(self.iconImgView.mas_right).offset(8).priorityHigh();
        make.right.equalTo(self.titleLB);
    }];
    
    [self.segementLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(1);
    }];
}

#pragma mark - Setter && Getter
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Bubble_mediaIcon"]];
    }
    return _iconImgView;
}

- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = FONT_SIZE(TitleFontSize);
        _titleLB.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByTruncatingTail;
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.numberOfLines = 1;
        _titleLB.textColor = [UIColor whiteColor];
    }
    return _titleLB;
}


- (UILabel *)playTimeLB{
    if (!_playTimeLB) {
        _playTimeLB = [[UILabel alloc] init];
        _playTimeLB.font = FONT_SIZE(SubTitleFontSize);
        _playTimeLB.textColor = [UIColor whiteColor];
        _titleLB.textAlignment = NSTextAlignmentLeft;
    }
    return _playTimeLB;
}

- (UILabel *)ratioLB{
    if (!_ratioLB) {
        _ratioLB = [[UILabel alloc] init];
        _ratioLB.font = FONT_SIZE(SubTitleFontSize);
        _ratioLB.textColor = [UIColor whiteColor];
        
    }
    return _ratioLB;
}

- (UILabel *)fileSizeLB{
    if (!_fileSizeLB) {
        _fileSizeLB = [[UILabel alloc] init];
        _fileSizeLB.font = FONT_SIZE(SubTitleFontSize);
        _fileSizeLB.textColor = [UIColor whiteColor];
    }
    return _fileSizeLB;
}

- (UIImageView *)segementLine{
    if (!_segementLine) {
        _segementLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CellWidth, 1)];
        _segementLine.image = [UIImage imageWithLineWithImageView:_segementLine color:RGB(151, 151, 151,1) length:3 interval:1];
    }
    return _segementLine;
}

@end
