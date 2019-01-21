//
//  DataHandleTool.h
//  TinyPlayer_V1
//
//  Created by hong on 2017/6/26.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandleTool : NSObject

+ (void)dataArchiverWithData:(id)data withPath:(NSString *)path;

+(id)dataUnarchiveWithPath:(NSString *)path;

@end
