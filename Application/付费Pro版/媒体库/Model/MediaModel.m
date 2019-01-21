//
//  MediaModel.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/6/4.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "MediaModel.h"
#import "PlayerTool.h"
@implementation MediaModel

MJCodingImplementation;
- (void)setMediaLength:(CGFloat)mediaLength{
    if (_mediaLength != mediaLength) {
        _mediaLength = mediaLength;
    }
}


- (NSString  *)allPlayTime{
    if (self.mediaLength) {
        _allPlayTime = [PlayerTool takeTimeStrTimeValue:self.mediaLength];
    }else{
        _allPlayTime = @"00:00:00";
    }
    return _allPlayTime;
}

- (NSString *)recordPlayTime{
        if (self.recordLength) {
            _recordPlayTime = [PlayerTool takeTimeStrTimeValue:self.recordLength];
        }else{
            _recordPlayTime = @"00:00:00";
        }
    return _recordPlayTime;
}

- (NSInteger)rankNumber{
    if (!_rankNumber) {
        _rankNumber = 1;
    }
    return _rankNumber;
}

//- (UIImage *)thumbnail{
//    if (!_thumbnail) {
//        _thumbnail = [UIImage imageNamed:@""];
//    }
//    return _thumbnail;
//}



@end
