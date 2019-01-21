//
//  HTAdTool.h
//  TinyPlayer_V1
//
//  Created by Mr.h on 5/20/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#define ADTOOL [HTAdTool share]
#define BANNER [HTAdTool share].bannerView
#define NOAD [HTAdTool share].NoAD



@protocol HTAdToolDelgate <NSObject>


/** 广告加载完成 */
- (void)AdLoadedSuccessful;


// 移除广告完成
- (void)removeAdComplete;
@end


/**
 1. 实现思路
 2. block,通知,代理
 
*/



@interface HTAdTool : NSObject
singleH()

/** delegate */
@property(nonatomic,weak)id<HTAdToolDelgate> delegate;

/** bool */
@property(nonatomic,assign)BOOL NoAD;

/** interstitialAd */
@property(nonatomic,strong)GADInterstitial *interstitialAd;

/** bannerView */
@property(nonatomic, strong) GADBannerView *bannerView;

/** 加载banner */
+ (void)loadBanner;

- (void)showInterstitialAdWithVC:(UIViewController *)vc;

/** 广告appID */
+(NSString *)APPADID;
@end
