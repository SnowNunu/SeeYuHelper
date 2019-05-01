//
//  SYCoinVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYCoinVM.h"

@implementation SYCoinVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        self.user = [self.services.client currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
}

@end
