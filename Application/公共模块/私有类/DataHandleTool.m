//
//  DataHandleTool.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/6/26.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "DataHandleTool.h"

@implementation DataHandleTool

+ (void)dataArchiverWithData:(id)data withPath:(NSString *)path{
    
    dispatch_async(dispatch_queue_create("sub",DISPATCH_TARGET_QUEUE_DEFAULT), ^{
    
        NSString *fillePath = path;
        
        NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        fillePath  = [docPath stringByAppendingPathComponent:fillePath];
        
        [NSKeyedArchiver archiveRootObject:data toFile:fillePath];
        
    });
    
}


+(id)dataUnarchiveWithPath:(NSString *)path{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path =[docPath stringByAppendingPathComponent:path];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
