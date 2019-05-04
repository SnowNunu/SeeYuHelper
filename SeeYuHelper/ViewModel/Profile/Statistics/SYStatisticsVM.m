//
//  SYStatisticsVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYStatisticsVM.h"

@implementation SYStatisticsVM

- (void)initialize {
    [super initialize];
    self.title = @"主播数据统计";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
//    self.enterAboutViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        SYAboutVM *vm = [[SYAboutVM alloc] initWithServices:self.services params:nil];
//        [self.services pushViewModel:vm animated:YES];
//        return [RACSignal empty];
//    }];
}

@end
