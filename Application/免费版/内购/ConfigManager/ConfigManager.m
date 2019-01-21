//
//  ConfigManager.m
//  WhatsPlayer
//
//  Created by Mr.h on 12/9/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import "ConfigManager.h"
@interface ConfigManager()

@end

@implementation ConfigManager
singleM();



#pragma mark - Setter && Getter
// 用旧的key防止有的用户又得设置一次锁
- (BOOL)hasLock{
    _hasLock = [[NSUserDefaults standardUserDefaults] boolForKey:@"openLock"];
    return _hasLock;
}

@end
