//
//  SYNicknameModifyVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYNicknameModifyVM.h"

@implementation SYNicknameModifyVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        /// 获取昵称
        self.nickname = params[SYViewModelUtilKey];
        self.text = self.nickname;
    }
    return self;
}

- (void)initialize {
    [super initialize];
    @weakify(self);
    self.title = @"设置昵称";
    /// 去掉键盘管理
    self.keyboardEnable = NO;
    self.shouldResignOnTouchOutside = NO;
    self.validCompleteSignal = [RACObserve(self, text) map:^id(NSString *text) {
        @strongify(self);
        return @(text.length > 0 && ![text isEqualToString:self.nickname]);
    }];
    
    self.cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    self.completeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        /// 回调数据
        !self.callback ? : self.callback(self.text);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
}

@end
