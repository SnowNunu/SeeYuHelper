//
//  SYCommonProfileHeaderItemViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYCommonProfileHeaderItemViewModel.h"

@interface SYCommonProfileHeaderItemViewModel ()
/// 用户头像
@property (nonatomic, readwrite, strong) SYUser *user;
@end

@implementation SYCommonProfileHeaderItemViewModel
- (instancetype)initViewModelWithUser:(SYUser *)user{
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}
@end
