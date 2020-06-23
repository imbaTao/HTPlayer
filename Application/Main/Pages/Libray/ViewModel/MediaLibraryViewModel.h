//
//  MediaLibraryViewModel.h
//  WhatsPlayer
//
//  Created by Mr.h on 12/15/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MediaLibraryViewModelDelegate <NSObject>

// 数据初始化完成的赋值刷新
- (void)initDataComplete;

// 有新数据需要插入时的刷新
- (void)newDataNeedRefresh:(MediaModel *)infoModel;

@end


@interface MediaLibraryViewModel : NSObject

/** delegate */
@property(nonatomic,weak)id<MediaLibraryViewModelDelegate> delegate;

/** mediaArray */
@property(nonatomic,strong)NSMutableArray *mediaArray;

/** 本地模型 */
@property(nonatomic,strong)NSMutableArray *db_allNameArr;

/** isRenaming */
@property(nonatomic,assign)BOOL isRenaming;



// 刷新数据绑定显示数据源
- (void)initData;
@end

NS_ASSUME_NONNULL_END
