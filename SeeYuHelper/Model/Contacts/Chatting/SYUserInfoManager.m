//
//  SYUserInfoManager.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/16.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYUserInfoManager.h"

@implementation SYUserInfoManager

+ (SYUserInfoManager *)shareInstance {
    static SYUserInfoManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

// 根据id获取用户信息
- (void)getUserInfo:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    __block RCUserInfo *userInfo = [RCUserInfo new];
    NSDictionary *parameters = @{@"userId":userId};
    SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:parameters];
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_IMINFO parameters:subscript.dictionary];
    [[[[SYHTTPRequest requestWithParameters:paramters]
       enqueueResultClass:[SYUser class]]
      sy_parsedResults]
     subscribeNext:^(SYUser * user) {
         NSLog(@"register successful");
         userInfo.userId = user.userId;
         userInfo.name = user.userName;
         userInfo.portraitUri = user.userHeadImg;
     } error:^(NSError *error) {
         /// 失败回调
         NSLog(@"error");
         completion(userInfo);
         return;
     } completed:^{
         completion(userInfo);
         return;
     }];
}

@end
