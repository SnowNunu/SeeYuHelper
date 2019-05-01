//
//  SYListVideoOperation.m
//  ABVideoPlayer
//
//  Created by wildto on 2017/11/10.
//  Copyright © 2017年 wildto. All rights reserved.
//

#import "SYListVideoOperation.h"
#import <UIKit/UIKit.h>

@implementation SYListVideoOperation

- (void)videoPlayTask:(NSString *)videoFilePath
{
    //初始化AVUrlAsset获取对应视频的详细信息（AVAsset具有多种有用的方法和属性,比如时长,创建日期和元数据等）
    if ([[videoFilePath substringToIndex:7] isEqualToString:@"file://"]) {
        videoFilePath = [videoFilePath substringFromIndex:7];
    }
    NSURL *url = [NSURL fileURLWithPath:videoFilePath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSError *error;
    //创建一个读取媒体数据的阅读器AVAssetReader
    AVAssetReader *assetReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
 
    //获取视频的轨迹AVAssetTrack
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    //如果AVAssetTrack信息为空，直接返回
    if (!videoTracks.count) {
        return;
    }
    
    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    //获取视频图像方向
    UIImageOrientation orientation = [self orientationFromAVAssetTrack:videoTrack];
    
    /**
     摘自http://www.jianshu.com/p/6f55681122e4
     iOS系统定义了很多很多视频格式，让人眼花缭乱。不过一旦熟悉了它的命名规则，其实一眼就能看明白。
     kCVPixelFormatType_{长度|序列}{颜色空间}{Planar|BiPlanar}{VideoRange|FullRange}
     */
    //至于为啥设置这个，网上说是经验
    //其他用途，如视频压缩 m_pixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
    int m_pixelFormatType = kCVPixelFormatType_32BGRA;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:(int)m_pixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    //获取输出端口AVAssetReaderTrackOutput
    AVAssetReaderTrackOutput *videoReaderTrackOptput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:options];
    //添加输出端口，开启阅读器
    [assetReader addOutput:videoReaderTrackOptput];
    [assetReader startReading];
    
    //确保nominalFrameRate帧速率 > 0，碰到过坑爹的安卓拍出来0帧的视频
    //同时确保当前Operation操作没有取消
    while (assetReader.status == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0 && !self.isCancelled) {
        //依次获取每一帧视频
        CMSampleBufferRef sampleBufferRef = [videoReaderTrackOptput copyNextSampleBuffer];
        if (!sampleBufferRef) {
            return;
        }
        //根据视频图像方向将CMSampleBufferRef每一帧转换成CGImageRef
        CGImageRef imageRef = [SYListVideoOperation imageFromSampleBuffer:sampleBufferRef rotation:orientation];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.videoDecodeBlock) {
                self.videoDecodeBlock(imageRef, videoFilePath);
            }
            //释放内存
            if (sampleBufferRef) {
                CFRelease(sampleBufferRef);
            }
            if (imageRef) {
                CGImageRelease(imageRef);
            }
        });
        //根据需要休眠一段时间；比如上层播放视频时每帧之间是有间隔的，这里设置0.035，本来应该根据视频的minFrameDuration来设置，但是坑爹的又是安卓那边，这里参数信息有问题，倒是每一帧展示的速度异常，所有已只好手动设置。（网上看到的资料有的设置0.001）
        //[NSThread sleepForTimeInterval:CMTimeGetSeconds(videoTrack.minFrameDuration)];
        [NSThread sleepForTimeInterval:0.035];
    }
    //结束阅读器
    [assetReader cancelReading];
}

- (UIImageOrientation)orientationFromAVAssetTrack:(AVAssetTrack *)videoTrack
{
    UIImageOrientation orientation = UIImageOrientationUp;
    CGAffineTransform t = videoTrack.preferredTransform;
    if (t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
        orientation = UIImageOrientationRight;
    }
    else if (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
        orientation = UIImageOrientationLeft;
    }
    else if (t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
        orientation = UIImageOrientationUp;
    }
    else if (t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        orientation = UIImageOrientationDown;
    }
    return orientation;
}

//捕捉视频帧，转换成CGImageRef，不用UIImage的原因是因为创建CGImageRef不会做图片数据的内存拷贝，它只会当 Core Animation执行 Transaction::commit() 触发 layer -display时，才把图片数据拷贝到 layer buffer里。简单点的意思就是说不会消耗太多的内存！
+ (CGImageRef)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer rotation:(UIImageOrientation)orientation
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    //Generate image to edit
    unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    UIGraphicsEndImageContext();
    
    return image;
}

@end
