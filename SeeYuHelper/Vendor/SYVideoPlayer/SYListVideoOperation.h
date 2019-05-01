//
//  SYListVideoOperation.h
//  ABVideoPlayer
//
//  Created by wildto on 2017/11/10.
//  Copyright © 2017年 wildto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


/**
 视频文件解析回调
 @param videoImageRef 视频每帧截图的CGImageRef图像信息
 @param videoFilePath 视频路径地址
 */
typedef void(^VideoDecode)(CGImageRef videoImageRef, NSString *videoFilePath);

/**
 视频停止播放
 @param videoFilePath 视频路径地址
 */
typedef void(^VideoStop)(NSString *videoFilePath);

@interface SYListVideoOperation : NSBlockOperation

@property (nonatomic, copy) VideoDecode videoDecodeBlock;
@property (nonatomic, copy) VideoStop videoStopBlock;

- (void)videoPlayTask:(NSString *)videoFilePath;

@end
