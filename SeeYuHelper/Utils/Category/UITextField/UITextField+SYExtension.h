//
//  UITextField+SYExtension.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/9/6.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (SYExtension)

/// 限制最大长度
- (void)sy_limitMaxLength:(NSInteger)maxLength;

@end
