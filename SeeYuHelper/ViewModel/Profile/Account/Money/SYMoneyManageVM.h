//
//  SYMoneyManageVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYMoneyInfoModel.h"
#import "SYWithdrawalVM.h"
#import "SYWithdrawalRulesVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMoneyManageVM : SYVM

@property (nonatomic, strong) SYMoneyInfoModel *moneyInfo;

@property (nonatomic, strong) RACCommand *requestMoneyManageInfoCommand;

@property (nonatomic, strong) RACCommand *enterWithdrawalViewCommand;

@property (nonatomic, strong) RACCommand *enterWithdrawalRulesViewCommand;

@property (nonatomic, strong) RACCommand *enterPaymentsViewCommand;

@end

NS_ASSUME_NONNULL_END
