//
//  SYUnionWithdrawalVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYUnionConfirmVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYUnionWithdrawalVM : SYVM

@property (nonatomic, strong) RACCommand *enterUnionConfirmViewCommand;

@end

NS_ASSUME_NONNULL_END
