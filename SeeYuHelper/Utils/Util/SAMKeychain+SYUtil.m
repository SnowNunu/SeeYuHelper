//
//  SAMKeychain+SYUtil.m
//  WeChat
//
//  Created by senba on 2017/10/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SAMKeychain+SYUtil.h"

/// 登录账号的key
static NSString *const SY_RAW_LOGIN = @"SYRawLogin";
static NSString *const SY_SERVICE_NAME_IN_KEYCHAIN = @"com.fljj.SeeYu";
static NSString *const SY_DEVICEID_ACCOUNT         = @"DeviceID";

@implementation SAMKeychain (SYUtil)
+ (NSString *)rawLogin {
    return [[NSUserDefaults standardUserDefaults] objectForKey:SY_RAW_LOGIN];
}
+ (BOOL)setRawLogin:(NSString *)rawLogin {
    if (rawLogin == nil) NSLog(@"+setRawLogin: %@", rawLogin);
    
    [[NSUserDefaults standardUserDefaults] setObject:rawLogin forKey:SY_RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}
+ (BOOL)deleteRawLogin {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SY_RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}


+ (NSString *)deviceId{
    NSString * deviceidStr = [SAMKeychain passwordForService:SY_SERVICE_NAME_IN_KEYCHAIN account:SY_DEVICEID_ACCOUNT];
    if (deviceidStr == nil) {
        deviceidStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [SAMKeychain setPassword:deviceidStr forService:SY_SERVICE_NAME_IN_KEYCHAIN account:SY_DEVICEID_ACCOUNT];
    }
    return deviceidStr;
}
@end
