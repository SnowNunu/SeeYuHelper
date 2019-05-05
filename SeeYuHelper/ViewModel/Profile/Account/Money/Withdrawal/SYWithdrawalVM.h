//
//  SYWithdrawalVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYWithdrawalModel.h"
#import "SYAlipayWithdrawalVM.h"
#import "SYUnionWithdrawalVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYWithdrawalVM : SYVM

@property (nonatomic, strong) SYWithdrawalModel *model;

@property (nonatomic, strong) RACCommand *requestWithdrawalMoneyInfoCommand;

@property (nonatomic, strong) RACCommand *enterAlipayWithdrawalViewCommand;

@property (nonatomic, strong) RACCommand *enterUnionWithdrawalViewCommand;

@end

NS_ASSUME_NONNULL_END
