//
//  MBProgressHUD+HzyHUD.m
//  HZYToolBox
//
//  Created by hong  on 2018/12/17.
//  Copyright © 2018 HZY. All rights reserved.
//

#import "MBProgressHUD+HzyHUD.h"

@implementation MBProgressHUD (HzyHUD)

// 正在加载
+(void)loading{
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:superView animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    [superView bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    [self configStyle:hud];
}

// 正确
+ (void)showSuccess:(NSString *)successText {
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:superView animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    [superView bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *errorImage = [[UIImage imageNamed:@"HUD_Right"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.customView = [[UIImageView alloc] initWithImage:errorImage];
    hud.detailsLabel.text = successText;
    [self configStyle:hud];
    [hud hideAnimated:true afterDelay:1];
}

// 错误
+ (void)showError:(NSString *)errorText {
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:superView animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    [superView bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *errorImage = [[UIImage imageNamed:@"HUD_Error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.customView = [[UIImageView alloc] initWithImage:errorImage];
    hud.detailsLabel.text = errorText;
    [hud hideAnimated:true afterDelay:1];
    [self configStyle:hud];
}



// 隐藏
+(void)hide{
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:superView animated:NO];
}


// 设置颜色
+(void)configStyle:(MBProgressHUD *)hud{
    hud.removeFromSuperViewOnHide = true;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    hud.square = true;
    hud.label.textColor = [UIColor whiteColor];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//    hud.backgroundColor = ;
}


@end
