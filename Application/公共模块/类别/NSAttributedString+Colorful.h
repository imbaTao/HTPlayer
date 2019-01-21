//
//  NSAttributedString+Colorful.h
//  HZYToolBox
//
//  Created by hong  on 2018/9/3.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Colorful)
// 根据段落数和渲染颜色获取富文本
+ (instancetype)ColorFulStringWithString:(NSString *)string lengthArray:(NSArray *)lengthArray colorArray:(NSArray *)colorArray allColor:(UIColor *)allColor;
@end
