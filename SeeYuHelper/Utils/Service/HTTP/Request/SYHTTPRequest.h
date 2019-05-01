//
//  SYHTTPRequest.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  网络服务层 - 请求

#import <Foundation/Foundation.h>
#import "SYURLParameters.h"
#import "RACSignal+SYHTTPServiceAdditions.h"

@interface SYHTTPRequest : NSObject
/// 请求参数
@property (nonatomic, readonly, strong) SYURLParameters *urlParameters;
/**
 获取请求类
 @param params  参数模型
 @return 请求类
 */
+(instancetype)requestWithParameters:(SYURLParameters *)parameters;

@end
/// SYHTTPService的分类
@interface SYHTTPRequest (SYHTTPService)
/// 入队
- (RACSignal *) enqueueResultClass:(Class /*subclass of SYObject*/) resultClass;

@end
