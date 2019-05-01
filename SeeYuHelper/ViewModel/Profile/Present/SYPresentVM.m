//
//  SYPresentVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPresentVM.h"

@implementation SYPresentVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        self.user = [self.services.client currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"我的礼物";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
}

@end
