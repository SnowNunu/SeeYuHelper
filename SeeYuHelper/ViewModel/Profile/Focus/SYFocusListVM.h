//
//  SYFocusListVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYFocusListVM : SYVM

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestFocusListCommand;

@end

NS_ASSUME_NONNULL_END
