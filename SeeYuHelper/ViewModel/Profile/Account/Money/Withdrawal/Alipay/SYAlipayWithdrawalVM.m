//
//  SYAlipayWithdrawalVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAlipayWithdrawalVM.h"

@implementation SYAlipayWithdrawalVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"支付宝提现";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.enterAlipayConfirmViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYAlipayConfirmVM *vm = [[SYAlipayConfirmVM alloc] initWithServices:self.services params:@{SYViewModelUtilKey:params}];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
