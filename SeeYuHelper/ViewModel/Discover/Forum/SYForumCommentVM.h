//
//  SYForumCommentVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYForumModel.h"
#import "SYForumCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYForumCommentVM : SYVM

// 当前页数
@property (nonatomic, assign) int pageNum;

// 每页条数
@property (nonatomic, assign) int pageSize;

// 数据源数组
@property (nonatomic, strong) NSArray *datasource;

// 评论列表数组
@property (nonatomic, strong) NSArray *comments;

@property (nonatomic, strong) SYForumModel *model;

// 请求所有的话题列表
@property (nonatomic, strong) RACCommand *requestForumsCommentsCommand;

// 点赞评论
@property (nonatomic, strong) RACCommand *likeCommentCommand;

// 发布评论
@property (nonatomic, strong) RACCommand *postCommentCommand;

@end

NS_ASSUME_NONNULL_END
