//
//  HZYBubbleCell.m
//  TestApp
//
//  Created by hong  on 2018/8/3.
//  Copyright © 2018年 洪正烨. All rights reserved.
//

#import "HZYBubbleCell.h"
#import "UIImage+extension.h"
@implementation HZYBubbleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.iconView];
        [self addSubview:self.contentLB];
        [self addSubview:self.segementLine];
        [self layoutPageViews];
    }
    return self;
}

- (void)layoutPageViews{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10).priorityHigh();
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self);
    }];
    
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.right.offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [self.segementLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(1);
    }];
}

#pragma mark - Setter && Getter
- (UILabel *)contentLB{
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.font = FONT_SIZE(10);
        _contentLB.textColor = [UIColor whiteColor];
    }
    return _contentLB;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UIImageView *)segementLine{
    if (!_segementLine) {
        _segementLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CellWidth, 1)];
        _segementLine.image = [UIImage imageWithLineWithImageView:_segementLine color:[RGB(151, 151, 151,1) colorWithAlphaComponent:0.3]  length:3 interval:1];
    }
    return _segementLine;
}
@end
