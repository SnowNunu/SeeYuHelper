//
//  VideoEditingView.m
//  HZGame
//
//  Created by MH on 2017/5/31.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import "VideoEditingView.h"

@implementation VideoEditingView
+(void)showLoadingWith:(NSString *)title
{
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView * loadingView = [[UIView alloc] init];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.frame = CGRectMake(0, 0, 153, 109);
    loadingView.center = keyWindow.center;
    loadingView.tag = 8810;
    loadingView.layer.cornerRadius = 5;
    loadingView.layer.masksToBounds = YES;
    [keyWindow addSubview:loadingView];
    
    UIActivityIndicatorView * acti = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    acti.center = CGPointMake(76.5, 42);
    acti.color = [UIColor whiteColor];
    [loadingView addSubview:acti];
    
    //    CGAffineTransform transform = CGAffineTransformMakeScale(1.5, 1.5);
    //    acti.transform = transform;
    
    [acti startAnimating];
    
    UILabel * lab = [[UILabel alloc] init];
    lab.text = title;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor whiteColor];
    [loadingView addSubview:lab];
    lab.sd_layout.leftEqualToView(loadingView).bottomSpaceToView(loadingView, 25).rightEqualToView(loadingView).autoHeightRatio(0);
}
+(void)showVideoEditing
{
    [VideoEditingView showLoadingWith:@"视频处理中..."];
}
+(void)endVideoEditIng
{
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView * loading = (UIView *)[keyWindow viewWithTag:8810];
    if (loading) {
        [loading removeFromSuperview];
    }
}

+(void)qlowQuailtyWithInputURL:(NSURL *)inputURL blockHandler:(void (^)(BOOL, AVAssetExportSession *, NSURL *))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    NSString *path = [NSString stringWithFormat:@"%@VideoCompression/",NSTemporaryDirectory()];
    
    NSFileManager *fileManage = [[NSFileManager alloc] init];
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(![fileManage fileExistsAtPath:path]){
            [fileManage createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    if([fileManage fileExistsAtPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path]]){
        [fileManage removeItemAtPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path] error:nil];
    }
    
    NSURL *compressionVideoURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path]];
    session.outputURL = compressionVideoURL;
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = YES;
    session.videoComposition = [VideoEditingView getVideoComposition:asset];
    [session exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            switch ([session status]) {
                case AVAssetExportSessionStatusFailed:{
                    NSLog(@"Export failed: %@ : %@", [[session error] localizedDescription], [session error]);
                    handler(NO,nil, nil);
                    break;
                }case AVAssetExportSessionStatusCancelled:{
                    NSLog(@"Export canceled");
                    handler(NO,nil, nil);
                    break;
                }default:
                    handler(YES,session,compressionVideoURL);
                    break;
            }
        });
    }];
    
}
+ (AVMutableVideoComposition *)getVideoComposition:(AVAsset *)asset {
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    CGSize videoSize = videoTrack.naturalSize;
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if((t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0)){
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
    }
    composition.naturalSize    = videoSize;
    videoComposition.renderSize = videoSize;
    videoComposition.frameDuration = CMTimeMakeWithSeconds( 1 / videoTrack.nominalFrameRate, 600);
    
    AVMutableVideoCompositionLayerInstruction *layerInst = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInst setTransform:videoTrack.preferredTransform atTime:kCMTimeZero];
    
    AVMutableVideoCompositionInstruction *inst = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    inst.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    inst.layerInstructions = [NSArray arrayWithObject:layerInst];
    
    
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    videoComposition.instructions = [NSArray arrayWithObject:inst];
    return videoComposition;
}





+ (void)lowQuailtyWithInputURL:(NSURL *)inputURL blockHandler:(void (^)(BOOL, AVAssetExportSession *, NSURL *))handler
{
    AVAsset * firstAsset = [AVAsset assetWithURL:inputURL];
    
    if(firstAsset !=nil)
    {
        //FIXING ORIENTATION//
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:FirstAssetTrack];
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        CGSize videoSize = FirstAssetTrack.naturalSize;
        NSLog(@"%f--%f",videoSize.width,videoSize.height);
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)
        {
            CGAffineTransform trans = CGAffineTransformTranslate(firstTransform,0,firstTransform.tx-videoSize.height);
            [FirstlayerInstruction setTransform:trans atTime:kCMTimeZero];
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,nil];;
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMakeWithSeconds( 1 / FirstAssetTrack.nominalFrameRate, 600);
        MainCompositionInst.renderSize = videoSize;
        
        
        NSString *path = [NSString stringWithFormat:@"%@VideoCompression/",NSTemporaryDirectory()];
        NSFileManager *fileManage = [[NSFileManager alloc] init];
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            if(![fileManage fileExistsAtPath:path]){
                [fileManage createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
        });
        if([fileManage fileExistsAtPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path]]){
            [fileManage removeItemAtPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path] error:nil];
        }
        NSURL *compressionVideoURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path]];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:firstAsset presetName:AVAssetExportPresetMediumQuality];
        exporter.outputURL=compressionVideoURL;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 switch ([exporter status]) {
                     case AVAssetExportSessionStatusFailed:{
                         NSLog(@"Export failed: %@ : %@", [[exporter error] localizedDescription], [exporter error]);
                         handler(NO,nil, nil);
                         break;
                     }case AVAssetExportSessionStatusCancelled:{
                         NSLog(@"Export canceled");
                         handler(NO,nil, nil);
                         break;
                     }default: {
                         //                         AVAsset * tAsset = [AVAsset assetWithURL:compressionVideoURL];
                         //                         AVAssetTrack *tAssetTrack = [[tAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
                         //                         CGAffineTransform firstTransform = tAssetTrack.preferredTransform;
                         //                         CGSize videoSize = tAssetTrack.naturalSize;
                         //                         NSLog(@"%f--%f",videoSize.width,videoSize.height);
                         handler(YES,exporter,compressionVideoURL);
                         break;
                     }
                         
                 }
                 
             });
         }];
    }else{
        NSLog(@"视频文件有问题");
        handler(NO,nil, nil);
    }
}

@end
