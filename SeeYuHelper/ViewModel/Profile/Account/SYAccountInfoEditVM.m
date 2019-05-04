//
//  SYAccountInfoEditVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAccountInfoEditVM.h"
#import "SYPasswordModifyVM.h"

@implementation SYAccountInfoEditVM

- (void)initialize {
    [super initialize];
    self.title = @"账号信息";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.enterPasswordModifyViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYPasswordModifyVM *vm = [[SYPasswordModifyVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
