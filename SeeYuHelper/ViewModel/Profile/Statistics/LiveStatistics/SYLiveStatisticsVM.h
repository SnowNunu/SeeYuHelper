//
//  SYLiveStatisticsVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYLiveInfoModel.h"
#import "SYLiveDetailsVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveStatisticsVM : SYVM

@property (nonatomic, strong) SYLiveInfoModel *liveInfo;

@property (nonatomic, strong) RACCommand *reuqestLiveInfoCommand;

@property (nonatomic, strong) RACCommand *enterLiveDetailViewCommand;

@end

NS_ASSUME_NONNULL_END
