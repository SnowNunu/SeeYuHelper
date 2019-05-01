//
//  SYGiftVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/20.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGiftVM.h"
#import "SYDiamondsVM.h"

@implementation SYGiftVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if(self = [super initWithServices:services params:params]){
//        self.model = [SYAnchorsModel yy_modelWithJSON:params[SYViewModelUtilKey]];
        self.user = self.services.client.currentUser;
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"赠送礼物";
    self.prefersNavigationBarHidden = YES;
    self.sendGiftCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_GIFT_SEND parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
}

@end
