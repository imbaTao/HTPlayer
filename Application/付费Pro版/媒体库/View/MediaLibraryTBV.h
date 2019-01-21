//
//  MediaPlayTBV.h
//  TinyPlayer_V1
//
//  Created by Buddy.H on 2017/7/29.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaModel.h"
#import "PlayListHeaderView.h"

@protocol MediaPlayTBVDelegate <NSObject>

- (void)playInlistWithIndex:(NSIndexPath *)index;

@end

@interface MediaLibraryTBV : UITableView

/** delegate */
@property(nonatomic,weak) id <MediaPlayTBVDelegate> cellDelegate;


/** 数据 */
@property(nonatomic,strong)NSMutableArray *dataArr;

@end
