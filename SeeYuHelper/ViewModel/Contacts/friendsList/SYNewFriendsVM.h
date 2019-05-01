//
//  SYNewFriendsVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYNewFriendsVM : SYVM

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestNewFriendsCommand;

@property (nonatomic, strong) RACCommand *agreeFriendRequestCommand;

@end

NS_ASSUME_NONNULL_END
