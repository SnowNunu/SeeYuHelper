//
//  UILabel+SYExtension.m
//  WeChat
//
//  Created by senba on 2017/9/25.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "UILabel+SYExtension.h"

@implementation UILabel (SYExtension)
+ (instancetype)sy_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    return [self sy_labelWithText:text font:[UIFont systemFontOfSize:fontSize] textColor:textColor];
}


+ (instancetype)sy_labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *label = [[self alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label;
}

@end
