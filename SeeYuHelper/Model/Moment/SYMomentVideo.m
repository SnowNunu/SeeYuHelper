//
//  SYMomentVideo.m
//  WeChat
//
//  Created by senba on 2018/2/2.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "SYMomentVideo.h"

@implementation SYMomentVideo

- (void)setFileName:(NSString *)fileName{
    _fileName = [fileName copy];
    
    /// 这里设置封面和播放地址  因为这里都是本地的
    if (!SYStringIsNotEmpty(fileName)) return;
    NSString *urlStr = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    self.playUrl = [NSURL fileURLWithPath:urlStr];
    
    /// 获取视频第一帧
    self.coverImage = [UIImage sy_thumbnailImageForVideo:self.playUrl atTime:1];
}

@end
