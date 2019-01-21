//
//  PlayerVC_Free.m
//  WhatsPlayer
//
//  Created by Mr.h on 12/7/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import "PlayerVC_Free.h"

@interface PlayerVC_Free ()<GADInterstitialDelegate>
@property(nonatomic,assign)BOOL canShow ;
/** adShowTimes */
@property(nonatomic,assign)NSInteger adShowTimes;
@end

@implementation PlayerVC_Free
- (void)viewDidLoad {
    [super viewDidLoad];
    _canShow = true;
    _adShowTimes = 3;
}

- (void)doubleClickAction{
    if (!PLAYER.isPlaying && _canShow && _adShowTimes) {
        [ADTOOL showInterstitialAdWithVC:self];
        ADTOOL.interstitialAd.delegate = self;
    }
}


- (void)nextMediaMethod{
    [super nextMediaMethod];
    if (_canShow && _adShowTimes) {
        [ADTOOL showInterstitialAdWithVC:self];
         ADTOOL.interstitialAd.delegate = self;
    }
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    [PLAYER pause];
      --_adShowTimes;
    _canShow = false;
//    __weak typeof(self)weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         NSString *times =  [NSString stringWithFormat:@"%d",weakSelf.adShowTimes];
////        [weakSelf showAlerWithConternt:times];
//
//        HUD_Right(times);
//        NSLog(@"");
//    });
}


// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    if (!PLAYER.isPlaying){
        [PLAYER play];
    }
    
    NSString *times =  [NSString stringWithFormat:@"%d",_adShowTimes];
    HUD_Right(times);
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.canShow = true;
        
    });
}

@end
