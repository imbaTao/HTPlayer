//
//  HZYPopoverBackgroundView.m
//  HZYToolBox
//
//  Created by hong  on 2018/8/31.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "HZYPopoverBackgroundView.h"


@interface HZYPopoverBackgroundView()
@property (nonatomic, strong) UIImageView *arrowImageView;
@end


@implementation HZYPopoverBackgroundView
#define kArrowBase 0.0f
#define kArrowHeight 0.0f
#define kBorderInset 0.0f
@synthesize arrowDirection  = _arrowDirection;
@synthesize arrowOffset     = _arrowOffset;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(51, 51, 57,1);
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.cornerRadius = 10;
        self.layer.shadowRadius = 2.0;
        //        self.layer.shadowOpacity = 1;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

-(CGFloat)arrowOffset {
    return 0.0f;
}

+ (CGFloat)arrowBase
{
    return kArrowBase;
}

+ (CGFloat)arrowHeight{
    return kArrowHeight;
}

+ (UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(0,0,0,0);
}

//- (UIImage *)drawArrowImage:(CGSize)size
//{
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    [[UIColor clearColor] setFill];
//    CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, size.width, size.height));
//
//    CGMutablePathRef arrowPath = CGPathCreateMutable();
//    CGPathMoveToPoint(arrowPath, NULL, (size.width/2.0f), 0.0f); //Top Center
//    CGPathAddLineToPoint(arrowPath, NULL, size.width, size.height); //Bottom Right
//    CGPathAddLineToPoint(arrowPath, NULL, 0.0f, size.height); //Bottom Right
//    CGPathCloseSubpath(arrowPath);
//    CGContextAddPath(ctx, arrowPath);
//    CGPathRelease(arrowPath);
//
//    UIColor *fillColor = [UIColor yellowColor];
//    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
//    CGContextDrawPath(ctx, kCGPathFill);
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}
@end
