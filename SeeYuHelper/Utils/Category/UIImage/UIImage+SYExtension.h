//
//  UIImage+SYExtension.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/8/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SYExtension)
/**
 *  根据图片名返回一张能够自由拉伸的图片 (从中间拉伸)
 */
+ (UIImage *)sy_resizableImage:(NSString *)imgName;
+ (UIImage *)sy_resizableImage:(NSString *)imgName capInsets:(UIEdgeInsets)capInsets;


/// 返回一张未被渲染的图片
+ (UIImage *)sy_imageAlwaysShowOriginalImageWithImageName:(NSString *)imageName;
/// 获取视频某个时间的帧图片
+ (UIImage *)sy_thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/// /// 获取屏幕截图
///
/// @return 屏幕截图图像
+ (UIImage *)sy_screenShot;

- (UIImage *)sy_fixOrientation;

/*
 *  压缩图片方法(先压缩质量再压缩尺寸)
 */
- (NSData *)compressWithLengthLimit:(NSUInteger)maxLength;

/*
 *  压缩图片方法(压缩质量)
 */
- (NSData *)compressQualityWithLengthLimit:(NSInteger)maxLength;

/*
 *  压缩图片方法(压缩质量二分法)
 */
- (NSData *)compressMidQualityWithLengthLimit:(NSInteger)maxLength;

/*
 *  压缩图片方法(压缩尺寸)
 */
- (NSData *)compressBySizeWithLengthLimit:(NSUInteger)maxLength;

/*
 *  二分法压缩图片
 */
- (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize;

/*
 *  获取网络视频第一帧
 */
- (UIImage *) getVideoPreviewImage:(NSURL *)path;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/**
 *根据给定的size的宽高比自动缩放原图片、自动判断截取位置,进行图片截取
 * UIImage image 原始的图片
 * CGSize size 截取图片的size
 */
- (UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size;

@end
