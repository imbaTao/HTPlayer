//
//  BaseTabbarView.m
//  HZYToolBox
//
//  Created by hong  on 2018/6/29.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "BaseTabbarView.h"
@interface HZYTabbarButton : UIControl
/** buttonImgView */
@property(nonatomic,strong)UIImageView *buttonImgView;
@end

@implementation HZYTabbarButton
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.buttonImgView];
        [self layoutPageViews];
    }
    return self;
}

- (void)layoutPageViews{
    [self.buttonImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

#pragma mark - Setter && Getter
- (UIImageView *)buttonImgView{
    if (!_buttonImgView) {
        _buttonImgView = [[UIImageView alloc] init];
    }
    return _buttonImgView;
}
@end


@interface BaseTabbarView()
/** seletedImageArray */
@property(nonatomic,strong)NSArray *seletedImageArray;

/** unseletedImageArray */
@property(nonatomic,strong)NSArray *unseletedImageArray;

/** selectedIndex */
@property(nonatomic,assign)NSInteger selectedIndex;


@end

@implementation BaseTabbarView
static BaseTabbarView *_instance;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = StyleColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowOffset = CGSizeMake(0,-2);
        self.layer.shadowRadius = 4.0;
        [self addSubview:self.buttonBackBoardView];
        [self p_initCostomTabbar];
        [self layoutPageViews];
    }
    return self;
}

- (void)layoutPageViews{
    [self.buttonBackBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
}

- (void)p_initCostomTabbar{
    CGFloat width = SCREEN_W < SCREEN_H ? SCREEN_W : SCREEN_H;
    for (int i = 0; i < self.seletedImageArray.count; i++) {
        HZYTabbarButton *barButton = [[HZYTabbarButton alloc] init];
        barButton.tag = 100 + i;
        barButton.buttonImgView.image = [UIImage imageNamed:self.unseletedImageArray[i]];
        if (i == 0) {
            barButton.buttonImgView.image = [UIImage imageNamed:self.seletedImageArray[i]];
        }
        [barButton addTarget:self action:@selector(barBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonBackBoardView addSubview:barButton];
        [barButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(49);
            make.left.offset(i * width / self.seletedImageArray.count);
            make.bottom.offset(0);
            make.width.offset(width / self.seletedImageArray.count);
        }];
    }
}




#pragma mark - Reseponse
- (void)barBtnClickAction:(UIButton *)sender{
    // last unselected
    HZYTabbarButton *lastBtn = [self viewWithTag:100 + self.selectedIndex];
    lastBtn.buttonImgView.image = [UIImage imageNamed:self.unseletedImageArray[self.selectedIndex]];

    // current selected
    self.selectedIndex = sender.tag - 100;
    HZYTabbarButton *currentBtn = [self viewWithTag:sender.tag];
    currentBtn.buttonImgView.image = [UIImage imageNamed:self.seletedImageArray[self.selectedIndex]];
    [self.delegate changeBarIndexWithIndex:self.selectedIndex];
}

#pragma mark - Setter && Getter
- (UIView *)buttonBackBoardView{
    if (!_buttonBackBoardView) {
        _buttonBackBoardView = [[UIView alloc] init];
    }
    return _buttonBackBoardView;
}

- (NSArray *)seletedImageArray{
    if (!_seletedImageArray) {
        _seletedImageArray = @[@"Tabbar_library_selected",@"Tabbar_connect_selected",@"Tabbar_setting_selected"];
    }
    return _seletedImageArray;
}

- (NSArray *)unseletedImageArray{
    if (!_unseletedImageArray) {
        _unseletedImageArray = @[@"Tabbar_library_unselected",@"Tabbar_connect_unselected",@"Tabbar_setting_unselected"];
    }
    return _unseletedImageArray;
}

@end
