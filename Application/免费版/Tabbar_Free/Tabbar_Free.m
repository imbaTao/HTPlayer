//
//  Tabbar_Free.m
//  WhatsPlayer
//
//  Created by Mr.h on 11/26/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import "Tabbar_Free.h"

@interface Tabbar_Free()

@end

@implementation Tabbar_Free
singleM();
- (void)layoutPageViews{
    if (NOAD) {
        [self.buttonBackBoardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(49);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
    }else{
        [self.buttonBackBoardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(49);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
        
        [self.bannerBackBoardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.mas_equalTo(self.buttonBackBoardView.mas_top);
        }];
    }
}








#pragma mark - Setter && Getter
- (UIView *)bannerBackBoardView{
    if (!_bannerBackBoardView) {
        _bannerBackBoardView = [[UIView alloc] init];
        _bannerBackBoardView.backgroundColor = [UIColor clearColor];
        [_bannerBackBoardView addSubview:BANNER];
        [self addSubview:_bannerBackBoardView];
        [_bannerBackBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
            [BANNER mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }];
    }
    return _bannerBackBoardView;
}
@end
