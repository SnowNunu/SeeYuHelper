//
//  SYGiftPackageVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGiftPackageVM.h"

@implementation SYGiftPackageVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if(self = [super initWithServices:services params:params]){
        //        self.user = self.services.client.currentUser;
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"新手礼包";
    self.prefersNavigationBarHidden = YES;
    self.receiveGiftCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_GIFT_PACKAGE_RECEIVE parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYGiftPackageModel class]] sy_parsedResults]  takeUntil:self.rac_willDeallocSignal];
    }];
}

@end
