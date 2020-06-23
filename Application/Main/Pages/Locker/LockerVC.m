
//
//  LockerVC.m
//  TinyPlayer_V1
//
//  Created by Buddy.H on 2017/7/23.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "LockerVC.h"
#import "PlayerTool.h"
#import "SettingViewController.h"
@interface LockerVC ()

/** lockMaskView */
@property(nonatomic,strong) UIView *lockMaskView;

/** locker */
@property(nonatomic,strong) DBGuestureLock *locker;

/** tipsLB */
@property(nonatomic,strong)UILabel *tipsLB;

/** clearPasswordBtn */
@property(nonatomic,strong)UIButton *clearBtn;

@end

@implementation LockerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self)weakSelf = self;
    _locker =  [DBGuestureLock lockOnView:self.view onPasswordSet:^(DBGuestureLock *lock, NSString *password) {
        if (lock.firstTimeSetupPassword == nil) {
            lock.firstTimeSetupPassword = password;
            weakSelf.tipsLB.text = LOCALKEY(@"DrawAgain");
            [weakSelf showAlerWithConternt:weakSelf.tipsLB.text];
        }
    } onGetCorrectPswd:^(DBGuestureLock *lock, NSString *password) {
        if (lock.firstTimeSetupPassword && ![lock.firstTimeSetupPassword isEqualToString:DBFirstTimeSetupPassword]) {
            lock.firstTimeSetupPassword = DBFirstTimeSetupPassword;
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"openLock"];
            _tipsLB.text = LOCALKEY(@"PasswordSettingSuccess");
            [weakSelf showAlerWithConternt:weakSelf.tipsLB.text];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    weakSelf.completeBlock(true);
                }];
            });
        } else {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
            }];
            if (weakSelf.fromAppDelegate) {
                weakSelf.lockBlock();
            }
        }
    } onGetIncorrectPswd:^(DBGuestureLock *lock, NSString *password) {
        if (![lock.firstTimeSetupPassword isEqualToString:DBFirstTimeSetupPassword] && lock.firstTimeSetupPassword ) {
            weakSelf.tipsLB.text = LOCALKEY(@"RedrawTips");
            [weakSelf showAlerWithConternt:weakSelf.tipsLB.text];
            [DBGuestureLock clearGuestureLockPassword];
        } else {
            weakSelf.tipsLB.text = LOCALKEY(@"UnlockFail");
            [weakSelf showAlerWithConternt:weakSelf.tipsLB.text];
        }
    }];
    
    [self.view addSubview:self.lockMaskView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.clearBtn];
    [self.view addSubview:self.tipsLB];
    [self layoutPageViews];
    [PlayerTool orientationTo:UIInterfaceOrientationPortrait];
}

- (void)layoutPageViews{
    [_lockMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(34);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.offset(12);
    }];
    
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backButton);
        make.size.equalTo(_backButton);
        make.right.offset(-12);
    }];
    
    [_tipsLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(94);
        make.left.offset(20);
        make.right.offset(-20);
    }];
}


#pragma mark - response
- (void)backAction{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)clearAction{
    if ([DBGuestureLock getGuestureLockPassword]) {
        _tipsLB.text = LOCALKEY(@"DrawOriginTips");
        [self showAlerWithConternt:_tipsLB.text];
        [_locker removeFromSuperview];
        _locker = nil;
        _locker = [DBGuestureLock lockOnView:self.view onPasswordSet:^(DBGuestureLock *lock, NSString *password) {
        } onGetCorrectPswd:^(DBGuestureLock *lock, NSString *password) {
                [DBGuestureLock clearGuestureLockPassword];
                self.view.userInteractionEnabled = false;
                _tipsLB.text = LOCALKEY(@"ResetSuccess");
                [self showAlerWithConternt:_tipsLB.text];
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"openLock"];
                [DBGuestureLock clearGuestureLockPassword];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     __weak typeof(self)weakSelf = self;
                    [self dismissViewControllerAnimated:YES completion:^{
                        if (weakSelf.fromAppDelegate) {
                            weakSelf.lockBlock();
                        }else{
                             weakSelf.completeBlock(false);
                        }
                    }];
                });
        } onGetIncorrectPswd:^(DBGuestureLock *lock, NSString *password) {
            _tipsLB.text = LOCALKEY(@"ResetFail");
            [self showAlerWithConternt:_tipsLB.text];
        }];
        [_lockMaskView addSubview:self.locker];
    }
}

#pragma mark - setter&getter
- (UIView *)lockMaskView{
    if (!_lockMaskView) {
        _lockMaskView = [[UIView alloc] init];
        _lockMaskView.backgroundColor = [UIColor blackColor];
        [_lockMaskView addSubview:self.locker];
    }
    return _lockMaskView;
}


- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton creatBtnMethodWithColor:nil Image:@"back" title:nil VC:self selecter:@selector(backAction)];
    }
    return _backButton;
}

- (UIButton *)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [UIButton creatBtnMethodWithColor:nil Image:@"ClearLock" title:nil VC:self selecter:@selector(clearAction)];
    }
    return _clearBtn;
}


- (UILabel *)tipsLB{
    if (!_tipsLB) {
        _tipsLB = [UILabel creatCustomeLable:18 color:[UIColor whiteColor]];
        _tipsLB.textAlignment = NSTextAlignmentCenter;
        _tipsLB.numberOfLines = 0;
        if ([DBGuestureLock passwordSetupStatus]) {
            _tipsLB.text = LOCALKEY(@"UnlockTips");
        }else{
            _tipsLB.text = LOCALKEY(@"DrawCode");
        }
    }
    return _tipsLB;
}


- (void)showAlerWithConternt:(NSString *)content {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView dismissWithClickedButtonIndex:nil animated:true];
    });
    [alertView show];
}

- (BOOL)shouldAutorotate{
    return false;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
