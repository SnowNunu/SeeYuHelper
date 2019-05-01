//
//  SYCollocationVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYSpeedMatchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYCollocationVM : SYVM

@property (nonatomic, strong) NSArray *speedMatchList;

@property (nonatomic, strong) RACCommand *requestSpeedMatchCommand;

@property (nonatomic, strong) RACCommand *matchLikeCommand;

@end

NS_ASSUME_NONNULL_END
