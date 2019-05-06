//
//  SYWithdrawalRulesVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYWithdrawalRulesVM.h"

@implementation SYWithdrawalRulesVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"提现规则";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
}

@end
