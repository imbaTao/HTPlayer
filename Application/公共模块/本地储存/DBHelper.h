//
//  DBHelper.h
//  TinyPlayer_V1
//
//  Created by HT on 2017/11/11.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaModel.h"
#import <FMDatabase.h>
#import <FMDB.h>

@interface DBHelper : NSObject

/** DB */
@property(nonatomic,strong)FMDatabase *db;

/** queue */
@property(nonatomic,strong)FMDatabaseQueue *queue;


+ (BOOL)removeDataBase;

// 根据名字数组查询本地是否存在
+ (NSMutableArray *)takeAllMediaInfoWithNameArray:(NSMutableArray *)nameArray;

//+ (NSMutableArray *)takeAllMediaInfoWithPageNumber:(NSInteger)pageNumber;

+ (void)insertNewMediaInfo:(NSMutableArray *)modelArr;

+ (void)updateMediaDataWithMediaName:(NSMutableArray *)modelArr;

+ (void)updateMediaDataWithRankNumber:(NSMutableArray *)modelArr;


+ (void)deleteMediaDataWithUrl:(NSArray *)urlArr;

+ (void)deleteMediaDataWithMediaModel:(MediaModel *)model;

+(instancetype)shared;

@end
