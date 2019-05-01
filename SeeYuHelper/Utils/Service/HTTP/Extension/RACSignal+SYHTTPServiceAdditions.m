//
//  RACSignal+SYHTTPServiceAdditions.m
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "RACSignal+SYHTTPServiceAdditions.h"
#import "SYHTTPResponse.h"
@implementation RACSignal (SYHTTPServiceAdditions)

- (RACSignal *)sy_parsedResults {
    return [self map:^(SYHTTPResponse *response) {
        NSAssert([response isKindOfClass:SYHTTPResponse.class], @"Expected %@ to be an SYHTTPResponse.", response);
        return response.parsedResult;
    }];
}

@end
