//
//  LCActionSheet+SYExtension.m
//  WeChat
//
//  Created by senba on 2017/5/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "LCActionSheet+SYExtension.h"

@implementation LCActionSheet (SYExtension)
+ (void)sy_configureActionSheet
{
    LCActionSheetConfig *config = LCActionSheetConfig.config;
    
    /// 蒙版可点击
    config.darkViewNoTaped = NO;
    config.separatorColor = SY_MAIN_LINE_COLOR_1;
    config.buttonColor = [UIColor colorFromHexString:@"#3C3E44"];
    config.buttonFont = SYRegularFont_16;
    config.unBlur = YES;
    config.darkOpacity = .6f;
 
    /// 设置
    config.titleEdgeInsets = UIEdgeInsetsMake(27, 22, 27, 22);
    config.titleFont = SYRegularFont_13;
    
}
@end
