//
//  SYRechargeVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYVipVM.h"
#import "SYCoinVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYRechargeVM : SYVM

@property (nonatomic, strong) NSString *rechargeType;

@property (nonatomic, strong) SYVipVM *vipViewModel;

@property (nonatomic, strong) SYCoinVM *coinViewModel;

@end

NS_ASSUME_NONNULL_END
