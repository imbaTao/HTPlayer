//
//  PlayListHeaderView.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/6/4.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "PlayListHeaderView.h"
#import "UILabel+extension.h"
#import "UIButton+extension.h"
#import "MediaTool.h"
#import "MediaModel.h"
@interface PlayListHeaderView ()

/** 创建搜索框 */
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation PlayListHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.playListNameLB];
        [self addSubview:self.editBtn];
        [self addSubview:self.deleteListBtn];
        [self addSubview:self.searchController.searchBar];
        [self layoutPageViews];
    }
    return self;
}

- (void)layoutPageViews{
   [_playListNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
       make.center.equalTo(self);
   }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.offset(-8);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_deleteListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.offset(8);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    [_searchController.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.width.offset(100);
        make.centerX.equalTo(self);
    }];
}





#pragma mark - reponseActive
- (void)headBtnClick:(UIButton *)btn{
    [self.delegate headBtnClick:btn];
}


#pragma mark - setter&getter
- (UILabel *)playListNameLB{
    if (!_playListNameLB) {
        _playListNameLB = [UILabel creatCustomeLable:14 color:RGB(188, 188, 188, 188)];
        _playListNameLB.textAlignment = NSTextAlignmentCenter;
    }
    return _playListNameLB;
}


- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton creatBtnMethodWithColor:[UIColor clearColor]  Image:@"edit" title:@"edit" VC:self selecter:@selector(headBtnClick:)];
        _editBtn.titleLabel.hidden = YES;
    }
    return _editBtn;
}

- (UIButton *)deleteListBtn{
    if (!_deleteListBtn) {
        _deleteListBtn = [UIButton creatBtnMethodWithColor:[UIColor clearColor]  Image:@"edit" title:nil VC:self selecter:@selector(headBtnClick:)];
    }
    return _deleteListBtn;
}




@end
