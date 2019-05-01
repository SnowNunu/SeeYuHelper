//
//  NSError+SYExtension.m
//  WeChat
//
//  Created by senba on 2017/5/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "NSError+SYExtension.h"
#import "SYHTTPService.h"
@implementation NSError (SYExtension)
+ (NSString *)sy_tipsFromError:(NSError *)error{
    if (!error) return nil;
    NSString *tipStr = nil;
    /// 这里需要处理HTTP请求的错误
    if (error.userInfo[SYHTTPServiceErrorDescriptionKey]) {
        tipStr = [error.userInfo objectForKey:SYHTTPServiceErrorDescriptionKey];
    }else if (error.userInfo[SYHTTPServiceErrorMessagesKey]) {
        tipStr = [error.userInfo objectForKey:SYHTTPServiceErrorMessagesKey];
    }else if (error.domain) {
        tipStr = error.localizedFailureReason;
    } else {
        tipStr = error.localizedDescription;
    }
    return tipStr;
}
@end
