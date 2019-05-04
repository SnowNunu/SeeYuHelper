//
//  SYVideoInfoEditVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYUserInfoEditModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVideoInfoEditVM : SYVM

@property (nonatomic, strong) SYUserInfoEditModel *model;

@property (nonatomic, strong) NSString *type;   // 用来区分入口

@property (nonatomic, strong) RACCommand *requestUserShowInfoCommand;

@property (nonatomic, strong) RACCommand *uploadUserVideoCommand;

@property (nonatomic, strong) RACCommand *updateUserFlagCommand;

@property (nonatomic, strong) RACCommand *enterHomePageViewCommand;

@end

NS_ASSUME_NONNULL_END
