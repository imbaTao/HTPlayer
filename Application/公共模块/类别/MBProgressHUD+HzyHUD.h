//
//  MBProgressHUD+HzyHUD.h
//  HZYToolBox
//
//  Created by hong  on 2018/12/17.
//  Copyright © 2018 HZY. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN
#define HUD_Loading [MBProgressHUD loading];
#define HUD_Right(str) [MBProgressHUD showSuccess:str];
#define HUD_Error(str) [MBProgressHUD showError:str];
#define HUD_Hide [MBProgressHUD hide];
@interface MBProgressHUD (HzyHUD)
+(void)loading;
+ (void)showSuccess:(NSString *)successText;
+ (void)showError:(NSString *)errorText;
+(void)hide;
@end

NS_ASSUME_NONNULL_END
