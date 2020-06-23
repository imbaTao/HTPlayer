//
//  MediaPageModel.h
//  TinyPlayer_V1
//
//  Created by hong on 2017/7/9.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaModel.h"
@interface MediaPageModel : NSObject

/** listName */
@property(nonatomic,copy) NSString *listName;

/** pageNumber */
@property(nonatomic,assign) NSInteger pageNumber;

/** mediaModelArray */
@property(nonatomic,strong) NSMutableArray <MediaModel *> *mediaModelArray;

@end
