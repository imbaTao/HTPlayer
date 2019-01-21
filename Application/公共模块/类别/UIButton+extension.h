//
//  UIButton+extension.h
//  TinyPlayer_V1
//
//  Created by hong on 2017/5/6.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (extension)

+ (UIButton *)creatBtnMethodWithColor:(UIColor *)color Image:(NSString *)imageName title:(NSString *)title VC:(id)vc selecter:(SEL)select;


@end
