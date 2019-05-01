//
//  SYFriendDetailInfoVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYFriendDetialModel.h"
#import "SYUser.h"
#import "SYAuthenticationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYFriendDetailInfoVM : SYVM

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) SYUser *friendInfo;

@property (nonatomic, strong) SYAuthenticationModel *authInfo;

@property (nonatomic, strong) RACCommand *goBackCommand;

@property (nonatomic, strong) RACCommand *requestFriendDetailInfoCommand;

@end

NS_ASSUME_NONNULL_END
