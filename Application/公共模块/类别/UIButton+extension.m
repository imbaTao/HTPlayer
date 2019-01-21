//
//  UIButton+extension.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/5/6.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "UIButton+extension.h"

@implementation UIButton (extension)

+ (UIButton *)creatBtnMethodWithColor:(UIColor *)color Image:(NSString *)imageName title:(NSString *)title VC:(id)vc selecter:(SEL)select{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button addTarget:vc action:select forControlEvents:UIControlEventTouchUpInside];
    if (imageName != nil && ![imageName isEqualToString:@""]) {
     [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.alpha = 0;
    return button;
}

@end
