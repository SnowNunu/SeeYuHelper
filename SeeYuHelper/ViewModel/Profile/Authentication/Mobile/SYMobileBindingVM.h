//
//  SYMobileBindingVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/13.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMobileBindingVM : SYVM

// 获取验证码
@property (nonatomic, strong) RACCommand *getAuthCodeCommand;

// 绑定
@property (nonatomic, strong) RACCommand *bindCommand;

@end

NS_ASSUME_NONNULL_END
