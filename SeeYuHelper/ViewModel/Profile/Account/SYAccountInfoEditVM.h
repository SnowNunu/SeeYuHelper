//
//  SYAccountInfoEditVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAccountInfoEditVM : SYVM

@property (nonatomic, strong) RACCommand *enterPasswordModifyViewCommand;

@property (nonatomic, strong) RACCommand *enterMoneyManageViewCommand;

@end

NS_ASSUME_NONNULL_END
