//
//  SYRechargeVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYRechargeVM.h"

@implementation SYRechargeVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        self.rechargeType = params[SYViewModelUtilKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.vipViewModel = [[SYVipVM alloc] initWithServices:self.services params:nil];
    self.coinViewModel = [[SYCoinVM alloc] initWithServices:self.services params:nil];
}

@end
