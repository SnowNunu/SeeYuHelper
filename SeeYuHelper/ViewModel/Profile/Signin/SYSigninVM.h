//
//  SYSigninVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYSigninInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSigninVM : SYVM

@property (nonatomic, strong) SYSigninInfoModel *infoModel;

@property (nonatomic, strong) RACCommand *requestSigninInfoCommand;

@property (nonatomic, strong) RACCommand *userSigninCommand;

@end

NS_ASSUME_NONNULL_END
