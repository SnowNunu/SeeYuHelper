//
//  SYSignatureVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSignatureVM.h"

@implementation SYSignatureVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        /// 获取
        self.signature = params[SYViewModelUtilKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"设置签名";
    self.backTitle = @"";
    /// 去掉键盘管理
    self.keyboardEnable = NO;
    self.shouldResignOnTouchOutside = NO;
    
    self.validCompleteSignal = [RACObserve(self, signature) map:^id(NSString *text) {
        return @(text.length > 0 && ![text isEqualToString:self.params[SYViewModelUtilKey]]);
    }];
    
    @weakify(self);
    self.cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    self.completeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        /// 回调数据
        !self.callback ? : self.callback(self.signature);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
}

@end
