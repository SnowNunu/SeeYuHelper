//
//  SYRegisterVM.h
//  WeChat
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYVM.h"
#import "SYRegisterVM.h"

@interface SYRegisterVM : SYVM

@property (nonatomic, strong) NSString *age;

// 用户昵称
@property (nonatomic, strong) NSString *alias;

// 性别
@property (nonatomic, strong) NSString *gender;

// 职业
@property (nonatomic, strong) NSString *job;

// 收入
@property (nonatomic, strong) NSString *income;

// 身高
@property (nonatomic, strong) NSString *height;

// 婚姻状态
@property (nonatomic, strong) NSString *maritalStatus;

// 密码
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) RACCommand *registerCommand;

@property (nonatomic, strong) RACCommand *enterLoginViewCommand;

@end
