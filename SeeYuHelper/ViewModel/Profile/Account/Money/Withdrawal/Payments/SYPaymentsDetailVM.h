//
//  SYPaymentsDetailVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYPaymentsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPaymentsDetailVM : SYVM

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) SYPaymentsModel *model;

@property (nonatomic, strong) RACCommand *requestPaymentsDetailCommand;

@end

NS_ASSUME_NONNULL_END
