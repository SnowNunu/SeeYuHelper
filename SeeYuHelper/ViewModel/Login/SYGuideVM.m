//
//  SYGuideVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGuideVM.h"
#import "SYRegisterVM.h"
#import "SYLoginVM.h"

@implementation SYGuideVM

- (void)initialize {
    [super initialize];
    // 隐藏导航栏
    self.prefersNavigationBarHidden = YES;
    // 隐藏导航栏下细线
    self.prefersNavigationBarBottomLineHidden = YES;
    @weakify(self);
    self.registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        SYRegisterVM *vm = [[SYRegisterVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        SYLoginVM *vm = [[SYLoginVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
