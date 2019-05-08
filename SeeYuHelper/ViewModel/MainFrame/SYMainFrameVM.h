//
//  SYMainFrameVM.h
//  SeeYu
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYUserListModel.h"
#import "SYUserDetailVM.h"

@interface SYMainFrameVM : SYVM

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestUserListInfoCommand;

@property (nonatomic, strong) RACCommand *requestCustomerServiceCommand;

@property (nonatomic, strong) RACCommand *enterUserInfoViewCommand;

@end
