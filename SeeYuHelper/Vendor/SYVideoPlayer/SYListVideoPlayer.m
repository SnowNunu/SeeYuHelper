//
//  SYListVideoPlayer.m
//  ABVideoPlayer
//
//  Created by wildto on 2017/11/10.
//  Copyright © 2017年 wildto. All rights reserved.
//

#import "SYListVideoPlayer.h"

@implementation SYListVideoPlayer

static SYListVideoPlayer *_instance = nil;

+ (instancetype)sharedPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
        //初始化一个视频操作缓存字典
        _instance.videoOperationDict = [NSMutableDictionary dictionary];
        //初始化一个视频播放操作队列，并设置最大并发数（随意）
        _instance.videoOperationQueue = [[NSOperationQueue alloc] init];
        _instance.videoOperationQueue.maxConcurrentOperationCount = 1000;
    });
    return _instance;
}

- (void)startPlayVideo:(NSString *)filePath withVideoDecode:(VideoDecode)videoDecode
{
    [self checkVideoPath:filePath withBlock:videoDecode];
}

- (SYListVideoOperation *)checkVideoPath:(NSString *)filePath withBlock:(VideoDecode)videoBlock
{
    //视频播放操作Operation队列，就初始化队列，
    if (!self.videoOperationQueue) {
        self.videoOperationQueue = [[NSOperationQueue alloc] init];
        self.videoOperationQueue.maxConcurrentOperationCount = 1000;
    }
    //视频播放操作Operation存放字典，初始化视频操作缓存字典
    if (!self.videoOperationDict) {
        self.videoOperationDict = [NSMutableDictionary dictionary];
    }
    
    //初始化了一个自定义的NSBlockOperation对象，它是用一个Block来封装需要执行的操作
    SYListVideoOperation *videoOperation;
    
    //如果这个视频已经在播放，就先取消它，再次进行播放
    [self cancelVideo:filePath];
    
    videoOperation = [[SYListVideoOperation alloc] init];
    __weak SYListVideoOperation *weakVideoOperation = videoOperation;
    videoOperation.videoDecodeBlock = videoBlock;
    //并发执行一个视频操作任务
    [videoOperation addExecutionBlock:^{
        [weakVideoOperation videoPlayTask:filePath];
    }];
    //执行完毕后停止操作
    [videoOperation setCompletionBlock:^{
        //从视频操作字典里面异常这个Operation
        [self.videoOperationDict removeObjectForKey:filePath];
        //属性停止回调
        if (weakVideoOperation.videoStopBlock) {
            weakVideoOperation.videoStopBlock(filePath);
        }
    }];
    //将这个Operation操作加入到视频操作字典内
    [self.videoOperationDict setObject:videoOperation forKey:filePath];
    //add之后就执行操作
    [self.videoOperationQueue addOperation:videoOperation];
    
    return videoOperation;
}

- (void)reloadVideoPlay:(VideoStop)videoStop withFilePath:(NSString *)filePath
{
    SYListVideoOperation *videoOperation;
    if (self.videoOperationDict[filePath]) {
        videoOperation = self.videoOperationDict[filePath];
        videoOperation.videoStopBlock = videoStop;
    }
}

-(void)cancelVideo:(NSString *)filePath
{
    SYListVideoOperation *videoOperation;
    //如果所有视频操作字典内存在这个视频操作，取出这个操作
    if (self.videoOperationDict[filePath]) {
        videoOperation = self.videoOperationDict[filePath];
        //如果这个操作已经是取消状态，就返回。
        if (videoOperation.isCancelled) {
            return;
        }
        //操作完不做任何事
        [videoOperation setCompletionBlock:nil];
        
        videoOperation.videoStopBlock = nil;
        videoOperation.videoDecodeBlock = nil;
        //取消这个操作
        [videoOperation cancel];
        if (videoOperation.isCancelled) {
            //从视频操作字典里面异常这个Operation
            [self.videoOperationDict removeObjectForKey:filePath];
        }
    }
}

-(void)cancelAllVideo
{
    if (self.videoOperationQueue) {
        //根据视频地址这个key来取消所有Operation
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:self.videoOperationDict];
        for (NSString *key in tempDict) {
            [self cancelVideo:key];
        }
        [self.videoOperationDict removeAllObjects];
        [self.videoOperationQueue cancelAllOperations];
    }
}

@end
