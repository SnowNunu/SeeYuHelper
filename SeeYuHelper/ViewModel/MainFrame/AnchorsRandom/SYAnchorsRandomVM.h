//
//  SYAnchorsRandomVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/20.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYAnchorsRandomModel.h"
#import "SYAnchorRandomCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorsRandomVM : SYVM

@property (nonatomic, assign) int onlineNumber;

@property (nonatomic, strong) NSArray<SYAnchorRandomCellModel*> *datasource;

@property (nonatomic, strong) RACCommand *requestOnlineAnchorsList;

@end

NS_ASSUME_NONNULL_END
