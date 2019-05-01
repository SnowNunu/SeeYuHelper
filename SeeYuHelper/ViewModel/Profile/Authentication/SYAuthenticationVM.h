//
//  SYAuthenticationVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/13.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYAuthenticationModel.h"
#import "SYMobileBindingVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAuthenticationVM : SYVM

@property (nonatomic, strong) SYAuthenticationModel *authenticationModel;

@property (nonatomic, strong) RACCommand *requestAuthenticationStateCommand;

@property (nonatomic, strong) RACCommand *enterNextViewCommand;

@end

NS_ASSUME_NONNULL_END
