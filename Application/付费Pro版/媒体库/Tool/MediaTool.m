//
//  MediaTool.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/7/10.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "MediaTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation MediaTool
singleM()
/** searchPath */
+ (NSMutableArray *)comparisonOldAndNewMediaName:(NSMutableArray *)oldNameArr refreshBlock:(void(^)(MediaModel *infoModel))refreshBlock{
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:docsDir];
    NSString *fileName;
    while (fileName = [dirEnum nextObject]) {
        NSString *pathStr  = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],fileName];
        NSURL *url =  [NSURL fileURLWithPath:pathStr];
        fileName = [fileName stringByRemovingPercentEncoding];
        if (![oldNameArr containsObject:fileName]) {
            [oldNameArr addObject:fileName];
            MediaModel *infoModel = [[MediaModel alloc]init];
            dispatch_async(dispatch_queue_create(0, 0), ^{
                VLCMedia *tempMedia = [[VLCMedia alloc]initWithURL:url];
                tempMedia.length = [tempMedia lengthWaitUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
                dispatch_async(dispatch_get_main_queue(),^{
                    if (tempMedia.length.intValue > 0) {
                        infoModel.media = tempMedia;
                        infoModel.mediaLength = tempMedia.length.intValue / 1000;
                        infoModel.mediaName = fileName;
                        infoModel.mediaURL = url;
                        infoModel.mediaSize = [MediaTool takeSizeWithPath:pathStr fileManager:fileManager];
                        infoModel.canPlay = true;
                        refreshBlock(infoModel);
                    }
                });
            });
        }
    }
    return oldNameArr;
}



/** searchPath */
+ (NSArray *)takeLocalFilesPathAndName{
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:docsDir];
    NSString *fileName;
    NSMutableArray *filesPathArray = [NSMutableArray array];
     NSMutableArray *filesNameArray = [NSMutableArray array];
    while (fileName = [dirEnum nextObject]) {
        if (!fileName.length) {
            fileName = @"_";
        }
        [filesNameArray addObject:fileName];
        NSString *pathStr  = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],fileName];
        pathStr = [pathStr stringByRemovingPercentEncoding];
        [filesPathArray addObject:pathStr];
    }
    return @[filesPathArray,filesNameArray];
}


+ (void)takeNewMediaModelWithPathArray:(NSMutableArray *)pathArray nameArray:(NSMutableArray *)nameArray RefreshBlock:(void(^)(MediaModel *infoModel))refreshBlock{
    if (pathArray.count) {
        dispatch_async(dispatch_queue_create(0, 0), ^{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            for (int i = 0; i < pathArray.count; i++) {
                NSString *path = pathArray[i];
                MediaModel *infoModel = [[MediaModel alloc]init];
                NSURL *url =  [NSURL fileURLWithPath:path];
                VLCMedia *tempMedia = [[VLCMedia alloc] initWithURL:url];
                tempMedia.length = [tempMedia lengthWaitUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
                dispatch_async(dispatch_get_main_queue(),^{
                    if (tempMedia.length.intValue > 0) {
                        infoModel.media = tempMedia;
                        infoModel.mediaLength = tempMedia.length.intValue / 1000;
                        infoModel.mediaName = nameArray[i];
                        infoModel.mediaURL = url;
                        infoModel.mediaSize = [MediaTool takeSizeWithPath:path fileManager:fileManager];
                        infoModel.canPlay = true;
                        refreshBlock(infoModel);
                    }
                });
            }
        });
    }
}




+ (NSString *)takeSizeWithPath:(NSString *)path fileManager:(NSFileManager *)fileManager{
    unsigned long long size = [[fileManager attributesOfItemAtPath:path error:nil] fileSize];
    NSString *sizeText;
    if (size >= pow(10, 9)) { // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%zdB", size];
    }
    return sizeText;
}


+ (BOOL)checkHaveSameNameWithNewName:(NSString *)newFileName{
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString *doucumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //对于错误信息
    NSError *error;
    NSString *newPath = [NSString stringWithFormat:@"%@/%@",doucumentPath,newFileName];
    if ([manager fileExistsAtPath:newPath]) {
          return  true;
    }else{
      return false;
    }
}

+ (NSMutableArray *)deleteMovieFileWithMediaModelArr:(NSMutableArray *)mediaModelArr{
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString *doucumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    // 错误信息
    NSError *error;
    NSMutableArray *indexArray = [NSMutableArray array];
    for (int i = 0; i < mediaModelArr.count; i ++ ) {
        MediaModel *mediaModel = mediaModelArr[i];
        NSString *filePacketPath = [NSString stringWithFormat:@"%@/%@",doucumentPath,mediaModel.mediaName];
        if ([manager fileExistsAtPath:filePacketPath]) {
           if ([manager removeItemAtPath:filePacketPath error:&error]) {
               [indexArray addObject:[NSIndexPath indexPathForRow:mediaModel.rankNumber - 1 inSection:0]];
           }
        }
    }
    return indexArray;
}

#pragma mark - setter&getters
- (NSMutableArray *)mediaArr{
    if (!_mediaArr) {
        _mediaArr = [NSMutableArray array];
    }
    return _mediaArr;
}

@end
