//
//  SYUserInfoManager.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/16.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYUserInfoManager : NSObject

+ (SYUserInfoManager *)shareInstance;

// 根据id获取用户信息
- (void)getUserInfo:(NSString *)userId completion:(void (^)(RCUserInfo *))completion;

@end

NS_ASSUME_NONNULL_END
