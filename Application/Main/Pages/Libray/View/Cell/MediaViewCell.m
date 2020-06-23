//
//  MediaView_m
//  myProgramming
//
//  Created by hong on 2017/5/3.
//  Copyright © 2017年 hong. All rights reserved.
//

#import "MediaViewCell.h"
#import "MediaTool.h"
@interface MediaViewCell()

@end

@implementation MediaViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =  RGB(51,51,57, 1);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowRadius = 4.0;
        self.layer.cornerRadius = 5;
        [self addSubview:self.movieIconView];
        [self addSubview:self.circlImgView];
        [self addSubview:self.titleLB];
//        [self addSubview:self.playRecordAndAllTimeLB];
        [self layoutPageViews];
        
    }
    return self;
}

- (void)layoutPageViews{
//    if (Arrange) {
        [_movieIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(0);
            make.width.offset(MediaCellWidth);
            make.height.offset(MediaCellWidth * 1.3333);
        }];
    
        [_circlImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.left.offset(5);
            make.size.mas_equalTo(20);
        }];
    
      
        [_titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.movieIconView.mas_bottom).offset(0);
            make.bottom.offset(0);
            make.left.offset(3);
            make.right.offset(-3);
        }];
//    }
//else{
//        [_movieIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset(0);
//            make.top.offset(0);
//            make.height.mas_equalTo(100).priorityHigh();
//            make.width.mas_equalTo(133);
//        }];
//
//        [_titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_movieIconView.mas_top).offset(2);
//            make.left.mas_equalTo(_movieIconView.mas_right).offset(3).priorityHigh();
////            make.bottom.mas_equalTo(_playRecordAndAllTimeLB.mas_top);
//            make.right.offset(-3);
//        }];
//
//        [_playRecordAndAllTimeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.offset(-5);
//            make.left.mas_equalTo(_movieIconView.mas_right).offset(8);
//        }];
//    }
    
//    _playRecordAndAllTimeLB.hidden = Arrange;
}





#pragma mark - setter&getter
- (UIImageView *)movieIconView{
    if (!_movieIconView) {
        _movieIconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MediaCellWidth, MediaCellWidth * 1.3333)];
        _movieIconView.contentMode = UIViewContentModeScaleToFill;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_movieIconView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _movieIconView.bounds;
        maskLayer.path = maskPath.CGPath;
        _movieIconView.layer.mask = maskLayer;
    }
    return _movieIconView;
}

- (UIImageView *)circlImgView{
    if (!_circlImgView) {
        _circlImgView = [[UIImageView alloc] init];
        _circlImgView.hidden = true;
    }
    return _circlImgView;
}


- (UIImageView *)backGroundImgView{
    if (!_backGroundImgView) {
        _backGroundImgView = [[UIImageView alloc]init];
        _backGroundImgView.backgroundColor =  RGB(51,51,57, 1);
        _backGroundImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        _backGroundImgView.layer.shadowOpacity = 0.8;
        _backGroundImgView.layer.shadowOffset = CGSizeMake(3, 3);
    }
    return _backGroundImgView;
}

- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [UILabel creatCustomeLable:9 color:[UIColor whiteColor]];
        _titleLB.numberOfLines = 0;
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.lineBreakMode =  NSLineBreakByTruncatingMiddle;
    }
    return _titleLB;
}

- (UILabel *)playRecordAndAllTimeLB{
    if (!_playRecordAndAllTimeLB) {
        _playRecordAndAllTimeLB = [UILabel creatCustomeLable:10 color:RGB(192, 192, 192, 1)];
        _playRecordAndAllTimeLB.text = @"00:00:00 /";
        _playRecordAndAllTimeLB.textAlignment = NSTextAlignmentRight;
        _playRecordAndAllTimeLB.hidden = true;
    }
    return _playRecordAndAllTimeLB;
}
@end
