//
//  NSError+SYExtension.h
//  WeChat
//
//  Created by senba on 2017/5/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (SYExtension)
+ (NSString *)sy_tipsFromError:(NSError *)error;
@end
