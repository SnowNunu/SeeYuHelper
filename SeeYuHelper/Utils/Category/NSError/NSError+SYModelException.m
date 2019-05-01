//
//  NSError+SYModelException.m
//  WeChat
//
//  Created by senba on 2017/9/30.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import "NSError+SYModelException.h"

// The domain for errors originating from SYModel.
static NSString * const SYModelErrorDomain = @"SYModelErrorDomain";

// An exception was thrown and caught.
static const NSInteger SYModelErrorExceptionThrown = 1;

// Associated with the NSException that was caught.
static NSString * const SYModelThrownExceptionErrorKey = @"SYModelThrownException";

@implementation NSError (SYModelException)

+ (instancetype)sy_modelErrorWithException:(NSException *)exception {
    NSParameterAssert(exception != nil);
    
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: exception.description,
                               NSLocalizedFailureReasonErrorKey: exception.reason,
                               SYModelThrownExceptionErrorKey: exception
                               };
    
    return [NSError errorWithDomain:SYModelErrorDomain code:SYModelErrorExceptionThrown userInfo:userInfo];
}

@end
