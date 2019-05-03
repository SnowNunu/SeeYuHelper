//
//  SYInfoSupplementVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/2.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYHobbyVM.h"
#import "SYCoverInfoEditVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYInfoSupplementVM : SYVM

@property (nonatomic, strong) SYUser *user;

@property (nonatomic, strong) RACCommand *requestUserInfoCommand;

@property (nonatomic, strong) RACCommand *uploadAvatarImageCommand;

@property (nonatomic, strong) RACCommand *updateUserInfoCommand;

@property (nonatomic, strong) RACCommand *enterHobbyChooseViewCommand;

@property (nonatomic, strong) RACCommand *enterUploadCoverViewCommand;

@end

NS_ASSUME_NONNULL_END
