//
//  SYFriendDetailInfoVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYFriendDetailInfoVM.h"
#import "SYAuthenticationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYFriendDetailInfoVC : SYVC

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SYFriendDetailInfoVM *viewModel;

@end

NS_ASSUME_NONNULL_END
