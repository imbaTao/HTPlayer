//
//  MediaControllView.h
//  TinyPlayer_V1
//
//  Created by Mr.H on 2017/12/8.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerTool.h"

@class MediaView;

@interface MediaControllView : UIView

/** mediaView */
@property(weak,nonatomic)MediaView *mediaView;

/** 播放进度条视图 */
@property (weak, nonatomic) IBOutlet UIView *progressView;

/** 暂停或播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;

/** 播放下一个按钮 */
@property(weak,nonatomic) IBOutlet UIButton *nextMediaBtn;

/** 已经播放的时间 */
@property(weak,nonatomic) IBOutlet UILabel *playedTimeLb;

/** 播放视频的所有时间 */
@property(weak,nonatomic)IBOutlet  UILabel *allPlayTimeLb;

/** 播放列表按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playListBtn;

/** 媒体设置按钮 */
@property (weak, nonatomic) IBOutlet UIButton *mediaConfigBtn;

/** 全屏切换按钮 */
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;


/** 刷新底部时间 */
- (void)refreshTime;

@end
