//
//  LinkGuideCell.m
//  HZYToolBox
//
//  Created by hong  on 2018/7/5.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "LinkGuideCell.h"

@implementation LinkGuideCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLB];
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(12);
            make.right.offset(0);
        }];
    }
    return self;
}

- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [UILabel creatLabelWithText:@"" textColor:[UIColor whiteColor] fontSize:12];
        _titleLB.numberOfLines  = 0;
        _titleLB.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLB;
}

@end
