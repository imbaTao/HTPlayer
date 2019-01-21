//
//  DBHelper.m
//  TinyPlayer_V1
//
//  Created by HT on 2017/11/11.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "DBHelper.h"





@implementation DBHelper

#define DB [DBHelper shared].db

#define DB_QUEUE [DBHelper shared].queue

#define DB_OPEN  [DBHelper checkOpenMethod]

#define DB_CLOSE [DBHelper checkCloseMethod]


static DBHelper *_DBHelper = nil;

+(instancetype)shared{
    if (!_DBHelper) {
        _DBHelper = [[DBHelper alloc] init];
        [_DBHelper initDataBase];
    }
    return _DBHelper;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_DBHelper == nil) {
        _DBHelper = [super allocWithZone:zone];
    }
    return _DBHelper;
}

-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}


#pragma mark - 初始化数据库
-(void)initDataBase{
    [_DBHelper.db open];
    [_DBHelper.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (_DBHelper.db.open) {
            bool result_course = [_DBHelper.db executeUpdate:@"CREATE TABLE IF NOT EXISTS MediaInfoTable (id integer PRIMARY KEY AUTOINCREMENT,mediaName text,mediaSize text,mediaLength real,recordLength real,thumbnail blob,canPlay bool,rankNumber integer);"];
            if (result_course) {
//                NSLog(@"成功创建媒体信息表");
            } else {
//                NSLog(@"创媒体信息表失败");
            }
        }
    }];
    [_DBHelper.db close];
}


#pragma mark - 对比旧媒体和新媒体，没有的数据库直接删掉
+ (NSMutableArray *)takeAllMediaInfoWithNameArray:(NSMutableArray *)nameArray{
    DB_OPEN;
    NSMutableArray *mediaArr_db = [NSMutableArray array];
    NSMutableArray *mediaNameArr = [NSMutableArray array];
    NSMutableArray *idArray = [NSMutableArray array];
    int rankNumber = 1;
    if (nameArray.count) {
    NSString *searchStr = [NSString stringWithFormat:@"SELECT * FROM MediaInfoTable   ORDER BY rankNumber asc"];
    FMResultSet *resultSet = [DB executeQuery:searchStr];
    while ([resultSet next]) {
        MediaModel *model = [[MediaModel alloc]init];
        model.mediaName = [resultSet stringForColumn:@"mediaName"];
        if (![mediaNameArr containsObject:model.mediaName] && [nameArray containsObject:model.mediaName]) {
            model.mediaLength = [resultSet doubleForColumn:@"mediaLength"];
            model.recordLength = [resultSet doubleForColumn:@"recordLength"];
            model.mediaSize = [resultSet stringForColumn:@"mediaSize"];
            model.thumbnail = [UIImage imageWithData:[resultSet dataForColumn:@"thumbnail"]];
            model.canPlay = true;
            model.rankNumber = rankNumber;
            model.mediaURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],model.mediaName]];
            model.media = [VLCMedia mediaWithURL:model.mediaURL];
            [model.media parseWithOptions:0 timeout:3];
            [idArray addObject:[NSNumber numberWithInteger:[resultSet intForColumn:@"id"]]];
            [mediaArr_db addObject:model];
            [mediaNameArr addObject:model.mediaName];
            rankNumber++;
           }
        }
    }
    
    [DB_QUEUE inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *idStr = [idArray componentsJoinedByString:@","];
        if (idArray.count) {
            NSString *str = [NSString stringWithFormat:@"delete from MediaInfoTable WHERE id NOT IN %@",[NSString stringWithFormat:@"(%@)",idStr]];
            BOOL result = [db executeUpdate:str];
            if (result) {
//                NSLog(@"删除旧表数据成功！");
            } else {
//                NSLog(@"删除旧表失败~");
            }
        }
    }];
    
    DB_CLOSE;
    return [NSMutableArray arrayWithObjects:mediaArr_db,mediaNameArr,nil];
}



#pragma mark - 插入新媒体数据
+ (void)insertNewMediaInfo:(NSMutableArray *)modelArr{
    DB_OPEN;
    [DB_QUEUE inDatabase:^(FMDatabase * _Nonnull db) {
    for (int i = 0; i < modelArr.count; i++) {
        MediaModel *model = modelArr[i];
        BOOL result = [DB executeUpdate:@"INSERT INTO MediaInfoTable (mediaName,mediaSize,mediaLength,recordLength,thumbnail,rankNumber,canPlay) VALUES (?,?,?,?,?,?,?);",
                       model.mediaName,
                       model.mediaSize,
                       [NSNumber numberWithFloat:model.mediaLength],
                       [NSNumber numberWithFloat:model.recordLength],
                       UIImagePNGRepresentation(model.thumbnail),
                        [NSNumber numberWithInteger:model.rankNumber],
                      [NSNumber numberWithInteger:model.canPlay]
                      ];
        if (result) {
 //           NSLog(@"插入成功");
        } else {
//            NSLog(@"插入失败");
        }
      }
    }];
    DB_CLOSE;
}


#pragma mark - 根据名字更新一个媒体的信息
+ (void)updateMediaDataWithMediaName:(NSMutableArray *)modelArr{
    DB_OPEN;
    [DB_QUEUE inDatabase:^(FMDatabase * _Nonnull db) {
        for (MediaModel *model in modelArr) {
            BOOL result = [DB executeUpdate:@"update MediaInfoTable set mediaSize = ?,mediaLength = ?,recordLength = ?,thumbnail = ?,rankNumber = ?,canPlay = ? where mediaName = ?",model.mediaSize,
                           [NSNumber numberWithFloat:model.mediaLength],
                           [NSNumber numberWithFloat:model.recordLength],
                           UIImagePNGRepresentation(model.thumbnail),
                           [NSNumber numberWithInteger:model.rankNumber],
                           [NSNumber numberWithBool: model.canPlay],
                           model.mediaName];
            if (result) {
     //           NSLog(@"更新媒体表成功");
            } else {
    //            NSLog(@"媒体表更新失败");
            }
        }
    }];
    DB_CLOSE;
}
#pragma mark - 根据名字更新一个媒体的信息
+ (void)updateMediaDataWithRankNumber:(NSMutableArray *)modelArr{
    DB_OPEN;
    [DB_QUEUE inDatabase:^(FMDatabase * _Nonnull db) {
        for (MediaModel *model in modelArr) {
            BOOL result = [DB executeUpdate:@"update MediaInfoTable set mediaName = ?, mediaSize = ?,mediaLength = ?,recordLength = ?,thumbnail = ?,canPlay = ? where rankNumber = ?",
                           model.mediaName,model.mediaSize,
                           [NSNumber numberWithFloat:model.mediaLength],
                           [NSNumber numberWithFloat:model.recordLength],
                           UIImagePNGRepresentation(model.thumbnail),[NSNumber numberWithBool: model.canPlay],
                           [NSNumber numberWithInteger:model.rankNumber]];
            if (result) {
         //       NSLog(@"更新媒体表成功");
            } else {
        //        NSLog(@"媒体表更新失败");
            }
        }
    }];
    DB_CLOSE;
}


#pragma mark - 删除一学期的数据
+ (void)deleteMediaData{
    DB_OPEN;
        BOOL result = [DB executeUpdate:@"delete from MediaInfoTable where canPlay = 0"];
        if (result) {
   //         NSLog(@"删除不存在媒体数据成功！");
        } else {
   //         NSLog(@"删除不存在媒体数据失败~");
        }
    DB_CLOSE;
}

+ (void)deleteMediaDataWithMediaModel:(MediaModel *)model{
    DB_OPEN;
    BOOL result = [DB executeUpdate:@"delete from MediaInfoTable where mediaName = ? and rankNumber = ?",model.mediaName,[NSNumber numberWithInteger:model.rankNumber]];
    if (result) {
    //    NSLog(@"删除成功！");
    } else {
   //     NSLog(@"删除失败~");
    }
    DB_CLOSE;
}


#pragma mark - Setter && Getter

/** FMDatabase对象 */
- (FMDatabase *)db{
    if (!_db) {
        _db = [FMDatabase databaseWithPath:[self dbPath]];
    }
    return _db;
}

/** 队列 */
- (FMDatabaseQueue *)queue{
    if (!_queue) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
    }
    return _queue;
}

#pragma mark - private
/** 数据库路径 */
- (NSString *)dbPath{
    //1.路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    NSString *contactPath = [doc stringByAppendingPathComponent:@".MediaInfo/Info_1.0.sqlite"];

    [[NSFileManager defaultManager] createDirectoryAtPath:[doc stringByAppendingPathComponent:@".MediaInfo"]
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
    return contactPath;
}


//删除数据库
+ (BOOL)removeDataBase {
    BOOL result;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //1.路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    NSString *contactPath = [doc stringByAppendingPathComponent:@".MediaInfo/Info_1.0.sqlite"];
    DB_CLOSE;
    result = [fileManager removeItemAtPath:contactPath error:&error];
    if (result) {
  //      NSLog(@"移除成功");
    }
    return result;
}

/** 检查数据库是否为开启状态 */
+ (void)checkOpenMethod{
    if (!DB.open) {
        [DB open];
    }
}

/** 关闭 */
+(void)checkCloseMethod{
    if (DB.open) {
        [DB close];
    }
}
@end
