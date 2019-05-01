//
//  SYForumCommentVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumCommentVM.h"
#import "SYForumResultModel.h"

@implementation SYForumCommentVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.model = [SYForumModel yy_modelWithJSON:params[SYViewModelUtilKey]];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.prefersNavigationBarBottomLineHidden = YES;
    self.title = @"回复话题";
    self.backTitle = @"";
    self.pageNum = 1;
    self.pageSize = 10;
    @weakify(self)
    self.requestForumsCommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *page) {
        @strongify(self)
        return [self requestRemoteCommentsDataSignalWithPage:page.integerValue];
    }];
    RAC(self,comments) = self.requestForumsCommentsCommand.executionSignals.switchToLatest;
    RAC(self,datasource) = [RACObserve(self, comments) map:^id(NSArray *commentsArray) {
        @strongify(self)
        return [self dataSourceWithComments:commentsArray];
    }];
    [self.requestForumsCommentsCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.likeCommentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *commentId) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"commentId":commentId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FORUM_COMMENT_LIKE parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYForumResultModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    self.postCommentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *commentContent) {
        @strongify(self)
        NSDictionary *params = @{@"commentUserid":self.services.client.currentUser.userId,@"commentForumid":self.model.forumId,@"commentContent":commentContent};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FORUM_COMMENT_POST parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYForumResultModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
}

- (RACSignal *)requestRemoteCommentsDataSignalWithPage:(NSUInteger)page {
    NSArray * (^mapComments)(NSArray *) = ^(NSArray *array) {
        if (page == 1) {
            /// 下拉刷新
        } else {
            /// 上拉加载
            array = @[(self.comments ?: @[]).rac_sequence, array.rac_sequence].rac_sequence.flatten.array;
        }
        return array;
    };
    SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
    subscript[@"userId"] = self.services.client.currentUser.userId;
    subscript[@"pageNum"] = @(page);
    subscript[@"pageSize"] = @(_pageSize);
    subscript[@"forumId"] = self.model.forumId;
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FORUM_COMMENT_LIST parameters:subscript.dictionary];
    SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
    return [[[self.services.client enqueueRequest:request resultClass:[SYForumCommentModel class]] sy_parsedResults] map:mapComments];
}

- (NSArray *)dataSourceWithComments:(NSArray *)comments {
    if (SYObjectIsNil(comments) || comments.count == 0) return nil;
    NSArray *datasources = [comments.rac_sequence map:^(SYForumCommentModel *model) {
        return model;
    }].array;
    return datasources ?: @[] ;
}

@end
