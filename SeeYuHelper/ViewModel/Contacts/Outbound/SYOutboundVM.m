//
//  SYOutboundVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/19.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYOutboundVM.h"

@implementation SYOutboundVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"外呼";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.prefersNavigationBarHidden = YES;
}

@end
