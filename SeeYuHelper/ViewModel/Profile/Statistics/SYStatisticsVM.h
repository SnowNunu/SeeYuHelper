//
//  SYStatisticsVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYLiveStatisticsVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYStatisticsVM : SYVM

@property (nonatomic, strong) RACCommand *enterLiveStatisticsViewCommand;

@property (nonatomic, strong) RACCommand *enterPresentListViewCommand;

@end

NS_ASSUME_NONNULL_END
