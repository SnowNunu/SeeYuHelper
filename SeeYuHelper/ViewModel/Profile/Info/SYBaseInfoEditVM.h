//
//  SYBaseInfoEditVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYHobbyVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYBaseInfoEditVM : SYVM

@property (nonatomic, strong) SYUser *user;

@property (nonatomic, strong) RACCommand *uploadAvatarImageCommand;

@property (nonatomic, strong) RACCommand *updateUserInfoCommand;

@property (nonatomic, strong) RACCommand *enterHobbyChooseViewCommand;

@end

NS_ASSUME_NONNULL_END
