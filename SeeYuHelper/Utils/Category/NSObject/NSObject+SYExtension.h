//
//  NSObject+SYExtension.h
//  WeChat
//
//  Created by senba on 2017/8/4.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SYExtension)
/// 获取 [from to] 之间的数据
+ (NSInteger) sy_randomNumberWithFrom:(NSInteger)from to:(NSInteger)to;

/// 根据获取到的
- (void)sy_convertNotification:(NSNotification *_Nullable)notification completion:(void (^ __nullable)(CGFloat duration, UIViewAnimationOptions options, CGFloat keyboardH))completion;


#pragma mark - Get..
/// Get class
- (BOOL)sy_isStringClass;
- (BOOL)sy_isNumberClass;
- (BOOL)sy_isArrayClass;
- (BOOL)sy_isDictionaryClass;
- (BOOL)sy_isStringOrNumberClass;
- (BOOL)sy_isNullOrNil;
- (BOOL)sy_isExist;

/// Get value
- (NSString *_Nullable)sy_stringValueExtension;


@end
