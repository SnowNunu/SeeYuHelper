//
//  SYPaymentsVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPaymentsVM.h"

@implementation SYPaymentsVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"收支明细";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
}

@end
