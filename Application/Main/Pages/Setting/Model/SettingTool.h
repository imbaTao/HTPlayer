//
//  SettingTool.h
//  敢聊播放器
//
//  Created by Mr.h on 2018/9/17.
//  Copyright © 2018年 Great. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingTool : NSObject
+ (NSMutableArray *)takeTheSettingModel;
+ (void)saveSettingModel:(NSMutableArray *)settingModelArray;
@end
