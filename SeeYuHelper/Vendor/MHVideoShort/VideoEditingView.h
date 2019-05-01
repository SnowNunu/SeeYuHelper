//
//  VideoEditingView.h
//  HZGame
//
//  Created by MH on 2017/5/31.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+SDAutoLayout.h"
//#import <AssetsLibrary/AssetsLibrary.h>
@interface VideoEditingView : UIView


/**
 显示视频处理loading
 */
+(void)showVideoEditing;
+(void)showLoadingWith:(NSString *)title;

/**
 结束书品处理loading
 */
+(void)endVideoEditIng;

+ (void)lowQuailtyWithInputURL:(NSURL *)inputURL blockHandler:(void (^)(BOOL success, AVAssetExportSession *session, NSURL *compressionVideoURL))handler;
@end
