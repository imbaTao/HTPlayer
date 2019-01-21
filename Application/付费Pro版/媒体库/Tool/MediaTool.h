//
//  MediaTool.h
//  TinyPlayer_V1
//
//  Created by hong on 2017/7/10.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MEDIALIST [MediaTool share].mediaArr
#define Arrange [MediaTool share].arrange

@interface MediaTool : NSObject
singleH();

typedef void(^refreshTable)(void);

/** playingNumber */
@property(nonatomic,assign)NSInteger playingNumber;
/** 1是横2是竖 */
@property(nonatomic,assign)BOOL arrange;
/** mediaArr */
@property(nonatomic,strong) NSMutableArray <MediaModel *> *mediaArr;
/** mediaModel */
@property(nonatomic,strong)MediaModel *mediaModel;
@property(nonatomic,copy)refreshTable refreshBlock;
/** searchPath */
+ (NSMutableArray *)comparisonOldAndNewMediaName:(NSMutableArray *)oldNameArr refreshBlock:(void(^)(MediaModel *infoModel))refreshBlock;
+ (BOOL)checkHaveSameNameWithNewName:(NSString *)newFileName;

/** 根据模型数组删除特定媒体 */
+ (NSMutableArray *)deleteMovieFileWithMediaModelArr:(NSMutableArray *)mediaModelArr;

+ (NSArray *)takeLocalFilesPathAndName;
+ (void)takeNewMediaModelWithPathArray:(NSMutableArray *)pathArray nameArray:(NSMutableArray *)nameArray RefreshBlock:(void(^)(MediaModel *infoModel))refreshBlock;
@end
