//
//  UILabel+extension.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/5/6.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "UILabel+extension.h"

@implementation UILabel (extension)
+ (UILabel *)creatLabelWithText:(NSString *)text textColor:(UIColor *)color fontSize:(CGFloat)size{
    UILabel *newLable = [[UILabel alloc] init];
    newLable.text = text;
    newLable.textColor = color;
    newLable.font = FONT_SIZE(size);
    newLable.textAlignment = NSTextAlignmentCenter;
    return newLable;
}

+ (UILabel *)creatCustomeLable:(float)font color:(UIColor *)color{
    UILabel *lable = [[UILabel alloc]init];
    lable.font = FONT_SIZE(font);
    lable.textColor = color;
    lable.numberOfLines = 1;
    return lable;
}


+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}
@end
