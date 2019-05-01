//
//  SYConstInline.h
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#ifndef SYConstInline_h
#define SYConstInline_h

/// 网络图片的占位图片
static inline UIImage *SYWebImagePlaceholder(){
    return SYImageNamed(@"placeholder_image");
}

/// 网络头像
static inline UIImage *SYWebAvatarImagePlaceholder(){
    return SYImageNamed(@"DefaultProfileHead_66x66");
}

/// 适配
static inline CGFloat SYPxConvertToPt(CGFloat px){
    return ceil(px * [UIScreen mainScreen].bounds.size.width/414.0f);
}


/// 辅助方法 创建一个文件夹
static inline void SYCreateDirectoryAtPath(NSString *path){
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (!isDir) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    } else {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
/// 重要数据备份的文件夹路径，通过NSFileManager来访问
static inline NSString *SYSeeYuDocDirPath(){
    return [SYDocumentDirectory stringByAppendingPathComponent:SY_SEEYU_DOC_NAME];
}
/// 通过NSFileManager来获取指定重要数据的路径
static inline NSString *SYFilePathFromSeeYuDoc(NSString *filename){
    NSString *docPath = SYSeeYuDocDirPath();
    SYCreateDirectoryAtPath(docPath);
    return [docPath stringByAppendingPathComponent:filename];
}

/// 微信轻量数据备份的文件夹路径，通过NSFileManager来访问
static inline NSString *SYSeeYuCacheDirPath(){
    return [SYCachesDirectory stringByAppendingPathComponent:SY_SEEYU_CACHE_NAME];
}
/// 通过NSFileManager来访问 获取指定轻量数据的路径
static inline NSString *SYFilePathFromSeeYuCache(NSString *filename){
    NSString *cachePath = SYSeeYuCacheDirPath();
    SYCreateDirectoryAtPath(cachePath);
    return [cachePath stringByAppendingPathComponent:filename];
}



#endif /* SYConstInline_h */
