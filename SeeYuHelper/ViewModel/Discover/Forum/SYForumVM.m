//
//  SYForumVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumVM.h"
#import "SYForumModel.h"
#import "SYForumCommentVM.h"

@implementation SYForumVM

- (void)initialize {
    self.pageNum = 1;
    self.pageSize = 10; // 每次加载10条数据
    @weakify(self)
    self.requestForumsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *page) {
        @strongify(self)
        return [self requestRemoteForumsDataSignalWithPage:page.integerValue];
    }];
    RAC(self,forums) = self.requestForumsCommand.executionSignals.switchToLatest;
    RAC(self,datasource) = [RACObserve(self, forums) map:^id(NSArray *forumsArray) {
        @strongify(self)
        return [self dataSourceWithForums:forumsArray];
    }];
    
    [self.requestForumsCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterForumsDetailViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYForumCommentVM *vm = [[SYForumCommentVM alloc] initWithServices:self.services params:params];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemoteForumsDataSignalWithPage:(NSUInteger)page {
    NSArray * (^mapForums)(NSArray *) = ^(NSArray *array) {
        if (page == 1) {
            /// 下拉刷新
        } else {
            /// 上拉加载
            array = @[(self.forums ?: @[]).rac_sequence, array.rac_sequence].rac_sequence.flatten.array;
        }
        return array;
    };
    SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
    subscript[@"userId"] = self.services.client.currentUser.userId;
    subscript[@"pageNum"] = @(page);
    subscript[@"pageSize"] = @(_pageSize);
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FORUM_LIST parameters:subscript.dictionary];
    SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
    return [[[self.services.client enqueueRequest:request resultClass:[SYForumModel class]] sy_parsedResults] map:mapForums];
}

- (NSArray *)dataSourceWithForums:(NSArray *)forums {
    if (SYObjectIsNil(forums) || forums.count == 0) return nil;
    NSArray *datasources = [forums.rac_sequence map:^(SYForumModel *model) {
        return model;
    }].array;
    return datasources ?: @[] ;
}

@end
