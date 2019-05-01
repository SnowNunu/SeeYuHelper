//
//  SYPicture.h
//  WeChat
//
//  Created by senba on 2017/12/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYObject.h"
#import "SYPictureMetadata.h"
@interface SYPicture : SYObject

/// 图片模型id
@property (nonatomic, readwrite, copy) NSString *picID;

@property (nonatomic, readwrite, copy) NSString *objectID;

@property (nonatomic, readwrite, assign) int photoTag;

/// < YES:固定为方形 NO:原始宽高比
@property (nonatomic, readwrite, assign) BOOL keepSize;
/// < w:180
@property (nonatomic, readwrite, strong) SYPictureMetadata *thumbnail;
/// < w:360 (列表中的缩略图)
@property (nonatomic, readwrite, strong) SYPictureMetadata *bmiddle;
/// < w:480
@property (nonatomic, readwrite, strong) SYPictureMetadata *middlePlus;
/// < w:720 (放大查看)
@property (nonatomic, readwrite, strong) SYPictureMetadata *large;
/// < (查看原图)
@property (nonatomic, readwrite, strong) SYPictureMetadata *largest;
/// < 原图
@property (nonatomic, readwrite, strong) SYPictureMetadata *original;
/// 图片标记类型
@property (nonatomic, readwrite, assign) SYPictureBadgeType badgeType;
@end
