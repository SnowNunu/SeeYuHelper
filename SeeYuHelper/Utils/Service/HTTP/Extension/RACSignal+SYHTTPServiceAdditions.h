//
//  RACSignal+SYHTTPServiceAdditions.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/7/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

// Convenience category to retreive parsedResults from SYHTTPResponses.
@interface RACSignal (SYHTTPServiceAdditions)
// This method assumes that the receiver is a signal of SYHTTPResponses.
//
// Returns a signal that maps the receiver to become a signal of
// SYHTTPResponses.parsedResult.
- (RACSignal *)sy_parsedResults;
@end
