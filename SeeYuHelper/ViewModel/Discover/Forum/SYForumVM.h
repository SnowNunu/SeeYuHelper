//
//  SYForumVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYForumVM : SYVM

// 当前页数
@property (nonatomic, assign) int pageNum;

// 每页条数
@property (nonatomic, assign) int pageSize;

// 数据源数组
@property (nonatomic, strong) NSArray *datasource;

// 论坛列表数组
@property (nonatomic, strong) NSArray *forums;

// 请求所有的话题列表
@property (nonatomic, strong) RACCommand *requestForumsCommand;

// 进入单个话题评论详情页面
@property (nonatomic, strong) RACCommand *enterForumsDetailViewCommand;

@end

NS_ASSUME_NONNULL_END
