//
//  SYCommonSwitchItemViewModel.m
//  WeChat
//
//  Created by senba on 2017/12/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYCommonSwitchItemViewModel.h"

@implementation SYCommonSwitchItemViewModel
- (void)setOff:(BOOL)off
{
    _off = off;
    
    [SYPreferenceSettingHelper setBool:off forKey:self.key];
}

- (void)setKey:(NSString *)key
{
    [super setKey:key];
    
    _off = [SYPreferenceSettingHelper boolForKey:key];
}
@end
