//
//  SYBaseInfoDetailVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYUser.h"
#import "SYBaseInfoEditVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYBaseInfoDetailVM : SYVM

@property (nonatomic, strong) SYUser *user;

@property (nonatomic, strong) RACCommand *requestUserShowInfoCommand;

@property (nonatomic, strong) RACCommand *enterInfoEditViewCommand;

@end

NS_ASSUME_NONNULL_END
