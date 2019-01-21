//
//  MonitorFileChangeUtils+one.h
//  HZYToolBox
//
//  Created by hong  on 2018/9/10.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import <MobileVLCKit/MobileVLCKit.h>
#import "MediaModel.h"
@interface VLCMediaThumbnailer (extension)
/** media */
@property(nonatomic,weak)MediaModel *model;
@end
