//
//  SYProfileVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYUserDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYProfileVM : SYVM

@property (nonatomic, strong) SYUser *user;

@property (nonatomic, strong) SYUserDetail *userDetail;

@property (nonatomic, strong) RACCommand *requestUserBaseInfoCommand;

@property (nonatomic, strong) RACCommand *requestUserDetailInfoCommand;

@property (nonatomic, strong) RACCommand *enterNextViewCommand;

@end

NS_ASSUME_NONNULL_END
