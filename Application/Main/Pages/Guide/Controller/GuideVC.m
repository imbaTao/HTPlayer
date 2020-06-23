//
//  GuideVC.m
//  TinyPlayer_V1
//
//  Created by Mr.h on 2018/4/25.
//  Copyright © 2018年 Great. All rights reserved.
//

#import "GuideVC.h"

@interface GuideVC () <UIScrollViewDelegate>

/** scorllView */
@property(nonatomic,strong)UIScrollView *guideScrollView;

/** pageControll */
@property(nonatomic,strong)UIPageControl *pageControll;

/** backBtn */
@property(nonatomic,strong)UIButton *backButton;

@end



@implementation GuideVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = true;
    [self.navigationController setNavigationBarHidden:true];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.guideScrollView];
    [self.view addSubview:self.backButton];
    [self layoutPageViews];
}

- (void)layoutPageViews{
    [_guideScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        
        make.left.offset(10);
        make.top.offset(10);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    _pageControll.currentPage = _guideScrollView.contentOffset.x / SCREEN_W;
}

#pragma mark - response
- (void)buttonClick{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Setter && Getter
- (UIScrollView *)guideScrollView{
    if (!_guideScrollView) {
        _guideScrollView = [[UIScrollView alloc] init];
        _guideScrollView.pagingEnabled = true;
        _guideScrollView.delegate = self;
        _guideScrollView.contentSize = CGSizeMake(SCREEN_H * 4, 0);
        for (int i = 1; i <= 4; i++) {
            NSString *picName;
            if (SCREEN_H < 1024) {
                picName = [NSString stringWithFormat:@"Guide_%zd_iPhone",i];
            }else if (SCREEN_H < 1336) {
                picName = [NSString stringWithFormat:@"Guide_%zd_iPad_768",i];
            }else{
                picName = [NSString stringWithFormat:@"Guide_%zd_iPad_1366",i];
            }
            
            
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:picName]];
            [_guideScrollView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(SCREEN_H * (i - 1));
                make.left.offset(0);
                make.size.mas_equalTo(CGSizeMake(SCREEN_W, SCREEN_H));
            }];
            imgView.backgroundColor = [UIColor clearColor];
        }
    }
    return _guideScrollView;
}

- (UIPageControl *)pageControll{
    if (!_pageControll) {
        _pageControll  = [[UIPageControl alloc] init];
        _pageControll.currentPage = 0;
        _pageControll.numberOfPages = 4;
        _pageControll.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControll.pageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControll;
}


- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton creatBtnMethodWithColor:nil Image:@"back" title:@"" VC:self selecter:@selector(buttonClick)];
        
    }
    return _backButton;
}



/** 强制旋转方向 */
- (void)orientationToPortrait:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
