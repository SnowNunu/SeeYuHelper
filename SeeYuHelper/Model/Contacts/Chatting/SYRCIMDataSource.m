//
//  SYRCIMDataSource.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYRCIMDataSource.h"
#import "SYUserInfoManager.h"

@implementation SYRCIMDataSource

+ (SYRCIMDataSource *)shareInstance {
    static SYRCIMDataSource *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    RCUserInfo *user = [RCUserInfo new];
    if (userId == nil || [userId length] == 0) {
        user.userId = userId;
        user.portraitUri = @"";
        user.name = @"";
        completion(user);
        return;
    }
    [[SYUserInfoManager shareInstance] getUserInfo:userId completion:^(RCUserInfo * _Nonnull user) {
        completion(user);
    }];
    return;
}

@end
