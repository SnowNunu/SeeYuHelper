//
//  FBKVOController+SYExtension.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/6/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  FBKVOController

#import "FBKVOController+SYExtension.h"

@implementation FBKVOController (SYExtension)

- (void)sy_observe:(id)object keyPath:(NSString *)keyPath block:(FBKVONotificationBlock)block
{
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:block];
}

- (void)sy_observe:(id)object keyPath:(NSString *)keyPath action:(SEL)action
{
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew action:action];
}
@end
