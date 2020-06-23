//
//  Player.h
//  TinyPlayer_V1
//
//  Created by Buddy.H on 2017/9/5.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLAYER [PlayerTool share].player
#define Playing [PlayerTool share].playingModel

@class MediaModel;
@interface PlayerTool : NSObject
singleH();

/** player */
@property (nonatomic, strong) VLCMediaPlayer *player;

/** 手指滑动比例 */
@property(nonatomic,assign)CGFloat mutiple;


/** playing */
@property(nonatomic,strong)MediaModel *playingModel;

/** 强制旋转方向 */
+ (void)orientationTo:(UIInterfaceOrientation)orientation;

/** 获取时间字符串 */
+ (NSString *)takeTimeStrTimeValue:(NSInteger)timeValue;

/** 获取字幕文件 */
+ (NSMutableArray *)searchSubTitlesFilePath;

+ (UIInterfaceOrientation)orientation;

@end
