//
//  SYPresentListVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYPresentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPresentListVM : SYVM

// 礼物类型(收到/送出)
@property (nonatomic, strong) NSString *presentsType;

// 礼物列表
@property (nonatomic, strong) NSArray *presentsArray;

// 获取礼物列表
@property (nonatomic, strong) RACCommand *requestPresentsListCommand;

@end

NS_ASSUME_NONNULL_END
