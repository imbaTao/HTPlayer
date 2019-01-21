//
//  UIImage+extension.h
//  myProgramming
//
//  Created by hong on 2017/4/30.
//  Copyright © 2017年 hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (extension)
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

// 倒圆角
+ (UIImage *)imageWithCornerRadius:(CGFloat)radius image:(UIImage *)image;

// 虚线
+(UIImage *)imageWithLineWithImageView:(UIImageView *)imageView color:(UIColor *)color length:(CGFloat)length interval:(CGFloat)interval;

/**
 *根据给定的size的宽高比自动缩放原图片、自动判断截取位置,进行图片截取
 * UIImage image 原始的图片
 * CGSize size 截取图片的size
 */
+(UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size;
@end
