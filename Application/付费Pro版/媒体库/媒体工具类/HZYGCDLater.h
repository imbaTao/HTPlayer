//
//  HZYGCDLater.h
//  HZYToolBox
//
//  Created by hong  on 2018/9/14.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZYGCDLater : NSObject
typedef void(^GCDTask)(BOOL cancel);
typedef void(^gcdBlock)(void);
+(GCDTask)gcdDelay:(NSTimeInterval)time task:(gcdBlock)block;
+(void)gcdCancel:(GCDTask)task;
+(void)gcdTest;
@end
