//
//  SYCommonProfileHeaderItemViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  用户信息的ItemViewModel

#import "SYCommonItemViewModel.h"
#import "SYUser.h"
@interface SYCommonProfileHeaderItemViewModel : SYCommonItemViewModel

/// 用户头像
@property (nonatomic, readonly, strong) SYUser *user;


- (instancetype)initViewModelWithUser:(SYUser *)user;
@end
