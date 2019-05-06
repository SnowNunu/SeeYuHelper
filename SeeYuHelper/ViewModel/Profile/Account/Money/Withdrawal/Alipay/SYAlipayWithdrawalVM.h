//
//  SYAlipayWithdrawalVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYAlipayConfirmVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAlipayWithdrawalVM : SYVM

@property (nonatomic, strong) RACCommand *enterAlipayConfirmViewCommand;

@end

NS_ASSUME_NONNULL_END
