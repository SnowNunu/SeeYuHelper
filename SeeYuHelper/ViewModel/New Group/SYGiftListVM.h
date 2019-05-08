//
//  SYGiftListVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/8.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYGiftListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftListVM : SYVM

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestGiftListInfoCommand;

@end

NS_ASSUME_NONNULL_END
