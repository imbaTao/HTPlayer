//
//  MediaLibraryViewModel.m
//  WhatsPlayer
//
//  Created by Mr.h on 12/15/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import "MediaLibraryViewModel.h"
#import "DBHelper.h"
#import "MediaTool.h"
#import "HZYGCDLater.h"
#import "MonitorFileChangeUtils.h"

@interface MediaLibraryViewModel()
/** 本地模型 */
@property(nonatomic,strong)NSMutableArray *db_modelAndNameArr;

/** 文件观察者 */
@property(nonatomic,strong)MonitorFileChangeUtils *filesWather;

/** 文件观察任务 */
@property(nonatomic,copy)GCDTask fileWatherTask;

@end

@implementation MediaLibraryViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initWather];
    }
    return self;
}

- (void)initData{
    // 先拿本地的路径和文件名
    NSArray *filePathAndNameArray = [MediaTool takeLocalFilesPathAndName];
    NSMutableArray *filePahArray = filePathAndNameArray[0];
    NSMutableArray *fileNameArray = filePathAndNameArray[1];
    _db_modelAndNameArr =  [DBHelper takeAllMediaInfoWithNameArray:fileNameArray];
    _mediaArray =  _db_modelAndNameArr[0];
    _db_allNameArr = _db_modelAndNameArr[1];
    NSMutableArray *newMediaPathArray = [NSMutableArray array];
    NSMutableArray *newMediaNameArray = [NSMutableArray array];
    for (int i = 0; i < filePahArray.count; i++) {
        if (![_db_allNameArr containsObject:fileNameArray[i]]) {
            [newMediaPathArray addObject:filePahArray[i]];
            [newMediaNameArray addObject:fileNameArray[i]];
        }
    }
    
    // 获取到新的媒体模型
    [MediaTool takeNewMediaModelWithPathArray:newMediaPathArray nameArray:newMediaNameArray RefreshBlock:^(MediaModel *infoModel) {
        if (![_db_allNameArr containsObject:infoModel.mediaName]) {
            [_db_allNameArr addObject:infoModel.mediaName];
            [infoModel.media parseWithOptions:0 timeout:3];
            [_mediaArray addObject:infoModel];
            infoModel.rankNumber = _mediaArray.count;
            [self.delegate newDataNeedRefresh:infoModel];
            [DBHelper insertNewMediaInfo:[NSMutableArray arrayWithObject:infoModel]];
        };
    }];
    
    // 代理通知控制器初始化完成
    [self.delegate initDataComplete];
}


// 初始化文件观察者
- (void)initWather{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    _filesWather = [[MonitorFileChangeUtils alloc] init];
    __weak typeof(self)weakSelf = self;
    [_filesWather watcherForPath:path block:^(NSInteger type) {
        if (_isRenaming) {
            _isRenaming = false;
            return;
        }
        if (_fileWatherTask) {
            [HZYGCDLater gcdCancel:_fileWatherTask];
        }
        _fileWatherTask = [HZYGCDLater gcdDelay:2 task:^{
            [weakSelf initData];
        }];
    }];
}
@end
