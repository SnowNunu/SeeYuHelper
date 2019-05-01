//
//  SYPictureMetadata.h
//  WeChat
//
//  Created by senba on 2017/12/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
/// 一张图片的元数据

#import "SYObject.h"

/// 图片标记
typedef NS_ENUM(NSUInteger, SYPictureBadgeType) {
    SYPictureBadgeTypeNone = 0, ///< 正常图片
    SYPictureBadgeTypeLong,     ///< 长图
    SYPictureBadgeTypeGIF,      ///< GIF
};


@interface SYPictureMetadata : SYObject
/// < Full image url
@property (nonatomic, readwrite, strong) NSURL *url;
/// < pixel width
@property (nonatomic, readwrite, assign) int width;
/// < pixel height
@property (nonatomic, readwrite, assign) int height;
/// < "WEBP" "JPEG" "GIF"
@property (nonatomic, readwrite, copy) NSString *type;
/// < Default:1
@property (nonatomic, readwrite, assign) int cutType;
/// 图片标记 （正常 GIF 长图）
@property (nonatomic, readwrite, assign) SYPictureBadgeType badgeType;
@end
