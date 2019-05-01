//
//  SYListVideoPlayer.h
//  ABVideoPlayer
//
//  Created by wildto on 2017/11/10.
//  Copyright © 2017年 wildto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYListVideoOperation.h"

@interface SYListVideoPlayer : NSObject

/** 视频播放操作Operation存放字典 */
@property (nonatomic, strong) NSMutableDictionary *videoOperationDict;
/** 视频播放操作Operation队列 */
@property (nonatomic, strong) NSOperationQueue *videoOperationQueue;

/**
 播放工具单例
 */
+ (instancetype)sharedPlayer;

/**
 播放一个本地视频

 @param filePath 视频路径
 @param videoDecode 视频每一帧的图像信息回调
 */
- (void)startPlayVideo:(NSString *)filePath withVideoDecode:(VideoDecode)videoDecode;

/**
 循环播放视频

 @param videoStop 停止回调
 @param filePath 视频路径
 */
- (void)reloadVideoPlay:(VideoStop)videoStop withFilePath:(NSString *)filePath;

/**
 取消视频播放同时从视频播放队列缓存移除
 @param filePath 视频路径
 */
-(void)cancelVideo:(NSString *)filePath;

/**
 取消所有当前播放的视频
 */
-(void)cancelAllVideo;

@end
