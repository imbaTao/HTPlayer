//
//  SettingStatusModel.h
//  WhatsPlayer
//
//  Created by Mr.h on 2018/7/14.
//  Copyright © 2018年 Great. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingStatusModel : NSObject
/** titleName */
@property(nonatomic,copy)NSString *titleName;

/** canTick */
@property(nonatomic,assign)BOOL canUse;

/** functionOpen */
@property(nonatomic,assign)BOOL functionOpen;

/** functionOpen */
@property(nonatomic,assign)BOOL buyed;

/** isSelected */
@property(nonatomic,assign)BOOL isSelected;

@end
