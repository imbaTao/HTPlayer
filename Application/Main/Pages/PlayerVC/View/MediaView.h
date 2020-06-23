//
//  MediaView.h
//  TinyPlayer_V1
//
//  Created by hong on 2017/5/6.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayListTBV.h"
#import "MediaTopInfoView.h"
#import "ConfigHUDView.h"
#import "MediaControllView.h"
@class PlayerVC;
@class MediaControllView;

@protocol mediaViewDelegate <NSObject>

// volume
- (void)changeVolume:(CGFloat)value;

// bright
- (void)changeBrightness:(CGFloat)value;

// progress
- (void)changePlayProgress:(CGFloat )value;

@end


@interface MediaView : UIView

/** delegate */
@property(nonatomic,weak) id<mediaViewDelegate> delegate;

/** screenMediaView */
@property(nonatomic,strong) UIView *playView;

/** playListTBV */
@property(nonatomic,strong) MediaPlayListTBV *playListTBV;

/** configView */
@property(nonatomic,strong)ConfigHUDView *configView;

/** controllView */
@property(nonatomic,weak)MediaControllView *controllView;


- (void)p_packUpListTBV;
- (void)p_unfoldListTBV;
@end
