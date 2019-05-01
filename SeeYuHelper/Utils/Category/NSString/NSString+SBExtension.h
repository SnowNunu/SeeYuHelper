//
//  NSString+SBExtension.h
//  WeChat
//
//  Created by senba on 2017/8/4.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SBExtension)
/// 消除收尾空格
- (NSString *)sb_removeBothEndsWhitespace;
/// 消除收尾空格+换行符
- (NSString *)sb_removeBothEndsWhitespaceAndNewline;
// 消除收尾空格
- (NSString *)sb_trimWhitespace;
/// 编码
- (NSString *)sb_URLEncoding;
// 消除所有空格
- (NSString *)sb_trimAllWhitespace;
// string转url
- (NSURL *)urlScheme:(NSString *)scheme;

// 根据服务器返回的时间转换成某分钟/天/月前
+ (NSString *)compareCurrentTime:(NSString *)str;

@end
