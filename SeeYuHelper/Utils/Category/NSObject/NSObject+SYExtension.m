//
//  NSObject+SYExtension.m
//  WeChat
//
//  Created by senba on 2017/8/4.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import "NSObject+SYExtension.h"

@implementation NSObject (SYExtension)

+ (NSInteger) sy_randomNumberWithFrom:(NSInteger)from to:(NSInteger)to{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}


- (void)sy_convertNotification:(NSNotification *)notification completion:(void (^ _Nullable)(CGFloat, UIViewAnimationOptions, CGFloat))completion
{
    // 按钮
    NSDictionary *userInfo = notification.userInfo;
    // 最终尺寸
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 开始尺寸
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // 动画时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    /// options
    UIViewAnimationOptions options = ([userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16 ) | UIViewAnimationOptionBeginFromCurrentState;
   
    /// keyboard height
    CGFloat keyboardH = 0;
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height){
        // up
        keyboardH = endFrame.size.height;
    }else if (endFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        // down
        keyboardH = 0;
    }else{
        // up
        keyboardH = endFrame.size.height;
    }
    /// 回调
    !completion?:completion(duration,options,keyboardH);
}



/// Get class
- (BOOL)sy_isStringClass { return [self isKindOfClass:[NSString class]]; }
- (BOOL)sy_isNumberClass { return [self isKindOfClass:[NSNumber class]]; }
- (BOOL)sy_isArrayClass { return [self isKindOfClass:[NSArray class]]; }
- (BOOL)sy_isDictionaryClass { return [self isKindOfClass:[NSDictionary class]]; }
- (BOOL)sy_isStringOrNumberClass { return [self sy_isStringClass] || [self sy_isNumberClass]; }
- (BOOL)sy_isNullOrNil { return !self || [self isKindOfClass:[NSNull class]]; }
- (BOOL)sy_isExist {
    if (self.sy_isNullOrNil) return NO;
    if (self.sy_isStringClass) return (self.sy_stringValueExtension.length>0);
    return YES;
}

/// Get value
- (NSString *)sy_stringValueExtension{
    if ([self sy_isStringClass]) return [(NSString *)self length]? (NSString *)self: @"";
    if ([self sy_isNumberClass]) return [NSString stringWithFormat:@"%@", self];
    return @"";
}


@end
