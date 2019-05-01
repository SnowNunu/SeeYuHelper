//
//  SYCoverInfoEditVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYUserInfoEditModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYCoverInfoEditVM : SYVM

@property (nonatomic, strong) SYUserInfoEditModel *model;

@property (nonatomic, strong) RACCommand *requestUserShowInfoCommand;

@property (nonatomic, strong) RACCommand *uploadUserCoverCommand;

@end

NS_ASSUME_NONNULL_END
