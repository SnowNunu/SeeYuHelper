//
//  SYHTTPRequest.m
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYHTTPRequest.h"
#import "SYHTTPService.h"

@interface SYHTTPRequest ()
/// 请求参数
@property (nonatomic, readwrite, strong) SYURLParameters *urlParameters;

@end

@implementation SYHTTPRequest

+(instancetype)requestWithParameters:(SYURLParameters *)parameters{
    return [[self alloc] initRequestWithParameters:parameters];
}

-(instancetype)initRequestWithParameters:(SYURLParameters *)parameters{
    
    self = [super init];
    if (self) {
        self.urlParameters = parameters;
    }
    return self;
}


@end

/// 网络服务层分类 方便SYHTTPRequest 主动发起请求
@implementation SYHTTPRequest (SYHTTPService)
/// 请求数据
-(RACSignal *) enqueueResultClass:(Class /*subclass of SYObject*/) resultClass {
    return [[SYHTTPService sharedInstance] enqueueRequest:self resultClass:resultClass];
}
@end

