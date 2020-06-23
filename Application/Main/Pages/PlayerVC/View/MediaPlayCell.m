//
//  MediaPlayCell.m
//  TinyPlayer_V1
//
//  Created by Buddy.H on 2017/7/29.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "MediaPlayCell.h"

@implementation MediaPlayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.mediaNameLB];
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame] ;
        self.selectedBackgroundView.backgroundColor = RGB(49, 49, 49, 1);
        [self.mediaNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.top.offset(3);
            make.bottom.offset(-3);
            make.left.offset(10);
            make.right.offset(-10);
        }];
    }
    return self;
}





#pragma mark - setter&getter
- (UILabel *)mediaNameLB{
    if (!_mediaNameLB) {
        _mediaNameLB = [UILabel creatCustomeLable:12 color:[UIColor
                                                            whiteColor]];
        _mediaNameLB.numberOfLines = 0;
        _mediaNameLB.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _mediaNameLB;
}


- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
