//
//  UILabel+extension.h
//  TinyPlayer_V1
//
//  Created by hong on 2017/5/6.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (extension)

+ (UILabel *)creatLabelWithText:(NSString *)text textColor:(UIColor *)color fontSize:(CGFloat)size;


+ (UILabel *)creatCustomeLable:(float)font color:(UIColor *)color;

+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font;
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font;
@end
