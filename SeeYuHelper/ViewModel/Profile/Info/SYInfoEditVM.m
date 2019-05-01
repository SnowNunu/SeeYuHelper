//
//  SYInfoEditVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYInfoEditVM.h"

@implementation SYInfoEditVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        //        self.user = [self.services.client currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"编辑资料";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
}

@end
