//
//  ConfigManager.h
//  WhatsPlayer
//
//  Created by Mr.h on 12/9/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HASLOCK [ConfigManager share].hasLock
@interface ConfigManager : NSObject
singleH();
/** bool */
@property(nonatomic,assign)BOOL hasLock;
@end
