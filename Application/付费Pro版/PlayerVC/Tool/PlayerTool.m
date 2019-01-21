//
//  Player.m
//  TinyPlayer_V1
//
//  Created by Buddy.H on 2017/9/5.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "PlayerTool.h"
#import "MediaTopInfoView.h"
#import "MediaModel.h"
#import "PlayerVC.h"




@implementation PlayerTool
singleM();


#pragma mark - Setter && Getter
- (VLCMediaPlayer *)player{
    if (!_player) {
        _player = [[VLCMediaPlayer alloc] init];
    }
    return _player;
}

- (void)setPlayingModel:(MediaModel *)playingModel{
    _playingModel = playingModel;
   _mutiple = _playingModel.mediaLength / SCREEN_W ;
//    if (_playingModel.mediaLength < 120) {
//        _mutiple = 0.3;
//    }else{
//        _mutiple = SCREEN_W < SCREEN_H ? 1.0 : 3.0;
//    }
}

#pragma mark - Private
/** 获取时间字符串 */
+ (NSString *)takeTimeStrTimeValue:(NSInteger)timeValue{
    NSString *tempStr;
    tempStr = [NSString stringWithFormat: @"%@", [NSString stringWithFormat:@"%02zd:%02zd:%02zd",timeValue / 3600, (timeValue / 60) % 60, timeValue % 60]];
    return tempStr;
}

/** 强制旋转方向 */
+ (void)orientationTo:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

/** 获取字幕文件 */
+ (NSMutableArray *)searchSubTitlesFilePath{
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:docsDir];
    NSString *fileName;
    NSMutableArray *dataArray = [NSMutableArray array];
    while (fileName = [dirEnum nextObject]) {
        if ([fileName hasSuffix:@".sub"] || [fileName hasSuffix:@".ass"] || [fileName hasSuffix:@".srt"]) {
            fileName = [fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dataArray addObject:fileName];
        }
    }
    return  dataArray;
}


+ (UIInterfaceOrientation)orientation{
    UIInterfaceOrientation orient = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    return orient;
}
@end
