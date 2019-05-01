//
//  SYHTTPResponse.m
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYHTTPResponse.h"
#import "SYHTTPServiceConstant.h"

@interface SYHTTPResponse ()

/// The parsed SYObject object corresponding to the API response.
/// The developer need care this data
@property (nonatomic, readwrite, strong) id parsedResult;
/// 自己服务器返回的状态码
@property (nonatomic, readwrite, assign) SYHTTPResponseCode code;
/// 自己服务器返回的信息
@property (nonatomic, readwrite, copy) NSString *msg;
@end

@implementation SYHTTPResponse

- (instancetype)initWithResponseObject:(id)responseObject parsedResult:(id)parsedResult
{
    self = [super init];
    if (self) {
        self.parsedResult = parsedResult ?:NSNull.null;
        self.code = [responseObject[SYHTTPServiceResponseCodeKey] integerValue];
        self.msg = responseObject[SYHTTPServiceResponseMsgKey];
    }
    return self;
}
@end

