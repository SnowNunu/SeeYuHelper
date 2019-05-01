//
//  SYDiamondsVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYDiamondsVM.h"

@implementation SYDiamondsVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        self.user = [self.services.client currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"我的钻石";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
}

@end
