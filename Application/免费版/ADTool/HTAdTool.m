//
//  HTAdTool.m
//  TinyPlayer_V1
//
//  Created by Mr.h on 5/20/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import "HTAdTool.h"
@interface HTAdTool()<GADRewardBasedVideoAdDelegate,GADInterstitialDelegate,GADBannerViewDelegate>
/** bannerID */
@property(nonatomic,copy)NSString *bannerID;

/** InterstitialID */
@property(nonatomic,copy)NSString *interstitialID;

/** testEnvironment */
@property(nonatomic,assign)BOOL testEnvironment;



@end

@implementation HTAdTool
singleM()

- (BOOL)NoAD{
     _NoAD = [[NSUserDefaults standardUserDefaults] boolForKey:@"NoAD"];
    return _NoAD;
}

#pragma mark - Methods
+(NSString *)APPADID{
    return @"ca-app-PUB-5027074375706040〜8663060130";
}

#pragma mark - delegate
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSString *rewardMessage =
    [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
     reward.type,
     [reward.amount doubleValue]];
    NSLog(rewardMessage);
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is received.");
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad has completed.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is closed.");
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    NSLog(@"Reward based video ad failed to load.");
}


#pragma mark - bannerDelgate
// 广告响应了
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    if (!NOAD) {
        [self.delegate AdLoadedSuccessful];
    }
}

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    
}
/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView{
    
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView{
    
}

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView{
    
}

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately before this method is called.
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView{
    
}


#pragma mark - method
+ (void)loadBanner{
    if (!NOAD) {
        [ADTOOL loadInterstitialAd];
        GADRequest *request = [GADRequest request];
        [BANNER loadRequest:request];
    }
}

- (void)loadInterstitialAd{
    self.interstitialAd = [[GADInterstitial alloc] initWithAdUnitID:self.interstitialID];
    GADRequest *request = [GADRequest request];
    [self.interstitialAd loadRequest:request];
}

// 展示插页广告
- (void)showInterstitialAdWithVC:(UIViewController *)vc{
    if (!NOAD) {
        if (!self.interstitialAd) {
            [self loadInterstitialAd];
        }
        
        if (self.interstitialAd.isReady) {
            [self.interstitialAd presentFromRootViewController:vc];
            [self loadInterstitialAd];
        }
    }
}



#pragma mark - private
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    
}

#pragma mark - Setter && Getter
- (GADBannerView *)bannerView{
    if (!_bannerView) {
#ifdef DEBUG
      _testEnvironment = true;
#endif
        _bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
        _bannerView.adUnitID = self.bannerID;
        _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (NSString *)bannerID{
    if (!_bannerID) {
        if (_testEnvironment) {
            _bannerID = @"ca-app-pub-3940256099942544/2934735716";
        }else{
             _bannerID = @"ca-app-pub-5027074375706040/1827776164";
        }
    }
    return _bannerID;
}

- (NSString *)interstitialID{
    if (!_interstitialID) {
        if (_testEnvironment) {
            _interstitialID = @"ca-app-pub-3940256099942544/4411468910";
        }else{
            _interstitialID = @"ca-app-pub-5027074375706040/5834894813";
        }
    }
    return _interstitialID;
}

@end
