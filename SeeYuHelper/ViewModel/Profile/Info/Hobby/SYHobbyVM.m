//
//  SYHobbyVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYHobbyVM.h"

@implementation SYHobbyVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        self.user = [self.services.client currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"添加标签";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    @weakify(self)
    self.requestHobbiesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSArray * (^mapAllHobbies)(NSArray *) = ^(NSArray *rankList) {
            return rankList.rac_sequence.array;
        };
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_GET path:SY_HTTTP_PATH_USER_HOBBIES parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[[self.services.client enqueueRequest:request resultClass:[SYHobbyModel class]] sy_parsedResults] map:mapAllHobbies];
    }];
    [self.requestHobbiesCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *hobbies) {
        self.datasource = hobbies;
    }];
    [self.requestHobbiesCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
