//
//  SYLoginVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLoginVM : SYVM

// 进入注册页面
@property (nonatomic, strong) RACCommand *enterRegisterViewCommand;

// 获取验证码
@property (nonatomic, strong) RACCommand *getAuthCodeCommand;

// 登录
@property (nonatomic, strong) RACCommand *loginCommand;

@end

NS_ASSUME_NONNULL_END
