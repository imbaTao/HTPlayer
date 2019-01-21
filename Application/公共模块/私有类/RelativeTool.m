//
//  RelativeTool.m
//  HZYToolBox
//
//  Created by hong  on 2018/7/6.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "RelativeTool.h"


#define IPHone6sSize CGSizeMake(375, 667)
#define W_RATIO  [UIScreen mainScreen].bounds.size.width / IPHone6sSize.width
#define H_RATIO   [UIScreen mainScreen].bounds.size.height / IPHone6sSize.height
@implementation RelativeTool
// 工作原理，根据6s 4.7寸屏幕,或设计图尺寸进行全设备相对适配
/**
 1.上左下右顺序
 */
+ (CGFloat)top:(CGFloat)topValue{
    topValue *= H_RATIO;
    return topValue;
}

+ (CGFloat)left:(CGFloat)leftValue{
    leftValue *= W_RATIO;
    return leftValue;
}

+ (CGFloat)bottom:(CGFloat)bottomValue{
    bottomValue *= H_RATIO;
    return bottomValue;
}

+ (CGFloat)right:(CGFloat)rightValue{
    rightValue *= W_RATIO;
    return rightValue;
}

@end
