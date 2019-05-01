//
//  SYMomentVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMomentVM : SYVM

@property (nonatomic, assign) int pageNum;

@property (nonatomic, assign) int pageSize;

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestMomentsCommand;

@end

NS_ASSUME_NONNULL_END
