//
//  SYLiveDetailsVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYLiveDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveDetailsVM : SYVM

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *reuqestLiveDetailCommand;

@end

NS_ASSUME_NONNULL_END
