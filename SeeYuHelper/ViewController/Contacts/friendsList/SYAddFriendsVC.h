//
//  SYAddFriendsVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYAddFriendsVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAddFriendsVC : SYVC

@property (nonatomic, strong) SYAddFriendsVM *viewModel;

@property (nonatomic, assign) BOOL sendRequest;

@end

NS_ASSUME_NONNULL_END
