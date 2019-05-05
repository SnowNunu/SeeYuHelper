//
//  SYStatisticsVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYStatisticsVM.h"
#import "SYPresentListVM.h"

@implementation SYStatisticsVM

- (void)initialize {
    [super initialize];
    self.title = @"主播数据统计";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.enterLiveStatisticsViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYLiveStatisticsVM *vm = [[SYLiveStatisticsVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.enterPresentListViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYPresentListVM *vm = [[SYPresentListVM alloc] initWithServices:self.services params:@{SYViewModelUtilKey:@"receive"}];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
