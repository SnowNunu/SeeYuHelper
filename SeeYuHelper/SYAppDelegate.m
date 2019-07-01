//
//  AppDelegate.m
//  SeeYu
//
//  Created by trc on 2019/01/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYAppDelegate.h"
#import "SYHomePageVC.h"
#import "SYRCIMDataSource.h"
#import "SYLoginVM.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
//#import <UMPush/UMessage.h>
#import <Bugly/Bugly.h>
#import "SYNotificationModel.h"
#import "SYOutboundModel.h"
#import <FFToast/FFToast.h>
#import "RongCallKit.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#if defined(DEBUG)||defined(_DEBUG)
#import <JPFPSStatus/JPFPSStatus.h>
//#import <FBMemoryProfiler/FBMemoryProfiler.h>
//#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
//#import "CacheCleanerPlugin.h"
//#import "RetainCycleLoggerPlugin.h"
#endif

@interface SYAppDelegate () <RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate>

@property (nonatomic, strong) CTCallCenter *callCenter;

@end

@implementation SYAppDelegate

//// 应用启动会调用的
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /// 初始化UI之前配置
    [self _configureApplication:application initialParamsBeforeInitUI:launchOptions];
    
    // Config Service
    self.services = [[SYViewModelServicesImpl alloc] init];
    // Config Nav Stack
    self.navigationControllerStack = [[SYNavigationControllerStack alloc] initWithServices:self.services];
    // Configure Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // 重置rootViewController
    SYVM *vm = [self _createInitialViewModel];
    if ([vm isKindOfClass:[SYHomePageVM class]]) {
        NSLog(@"%@",self.services.client.currentUser.userToken);
        [[RCIM sharedRCIM] connectWithToken:self.services.client.currentUser.userToken success:^(NSString *userId) {
            [Bugly setUserIdentifier:userId];
            [MobClick profileSignInWithPUID:userId];
            dispatch_async(dispatch_get_main_queue(), ^{
                RCUserInfo *rcUser = [[RCUserInfo alloc]initWithUserId:userId name:self.services.client.currentUser.userName portrait:self.services.client.currentUser.userHeadImg];
                [RCIM sharedRCIM].currentUserInfo = rcUser;
                [MBProgressHUD sy_showTips:@"登录成功"];
            });
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", status);
        } tokenIncorrect:^{
            // token永久有效，这种情形应该不会出现
            NSLog(@"token错误");
        }];
    }
    [self.services resetRootViewModel:vm];
    // 让窗口可见
    [self.window makeKeyAndVisible];
    
    /// 初始化UI后配置
    [self _configureApplication:application initialParamsAfterInitUI:launchOptions];
    
#if defined(DEBUG)||defined(_DEBUG)
    /// 调试模式
    [self _configDebugModelTools];
#endif
    
    // Save the application version info. must write last
    [[NSUserDefaults standardUserDefaults] setValue:SY_APP_VERSION forKey:SYApplicationVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"收到的推送消息内容为:%@",remoteNotificationUserInfo);
    return YES;
}



#pragma mark - 在初始化UI之前配置
- (void)_configureApplication:(UIApplication *)application initialParamsBeforeInitUI:(NSDictionary *)launchOptions {
    /// 显示状态栏
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    /// 配置键盘
    [self _configureKeyboardManager];
    
    /// 配置文件夹
    [self _configureApplicationDirectory];
    
    /// 配置FMDB
    [self _configureFMDB];
    
    // 初始化融云服务
    [[RCIM sharedRCIM] initWithAppKey:@"m7ua80gbmo03m"];    // 生产环境
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;  // 开启用户信息持久化
    [RCIM sharedRCIM].receiveMessageDelegate = self;    // 设置接收消息代理
    [RCIM sharedRCIM].userInfoDataSource = [SYRCIMDataSource shareInstance];
    [RCIM sharedRCIM].enableTypingStatus = YES; // 开启输入状态监听
    [RCIM sharedRCIM].connectionStatusDelegate = self;  // 设置连接状态代理
    
    _callWindows = [NSMutableArray new];
    
    // 使用bugly收集崩溃日志
    [Bugly startWithAppId:@"d3fb921f83"];
//    // 初始化友盟服务
    [UMConfigure initWithAppkey:@"5ca1a3aa3fc195e05e0000df" channel:@"App Store"];
    
    // 注册推送, 用于iOS8以及iOS8之后的系统
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    [application registerUserNotificationSettings:settings];
    [self registerTelephonyEvent];
    
    // 每次重启后将页标置为0
    YYCache *cache = [YYCache cacheWithName:@"SeeYuHelper"];
    [cache setObject:@"0" forKey:@"customeServiceFrom"];
}

/// 配置文件夹
- (void)_configureApplicationDirectory {
    /// 创建doc
    [SYFileManager createDirectoryAtPath:SYSeeYuDocDirPath()];
    /// 创建cache
    [SYFileManager createDirectoryAtPath:SYSeeYuCacheDirPath()];
    
    NSLog(@"SYSeeYuDocDirPath is [ %@ ] \n SYSeeYuCacheDirPath is [ %@ ]" , SYSeeYuDocDirPath() , SYSeeYuCacheDirPath());
}

/// 配置键盘管理器
- (void)_configureKeyboardManager {
    IQKeyboardManager.sharedManager.enable = YES;
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
}

/// 配置FMDB
- (void) _configureFMDB {
//    [[FMDatabaseQueue sharedInstance] inDatabase:^(FMDatabase *db) {
//        NSString *version = [[NSUserDefaults standardUserDefaults] valueForKey:SBApplicationVersionKey];
//        if (![version isEqualToString:SB_APP_VERSION]) {
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"senba_empty_1.0.0" ofType:@"sql"];
//            NSString *sql  = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//            /// 执行文件
//            if (![db executeStatements:sql]) {
//                SBLogLastError(db);
//            }
//        }
//    }];
}

#pragma mark - 在初始化UI之后配置
- (void)_configureApplication:(UIApplication *)application initialParamsAfterInitUI:(NSDictionary *)launchOptions {
    /// 配置ActionSheet
    [LCActionSheet sy_configureActionSheet];
    
    /// 预先配置平台信息
//    [SBUMengService configureUMengPreDefinePlatforms];
    
    /// 设置状态栏全局字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    @weakify(self);
    /// 监听切换根控制器的通知
    [[SYNotificationCenter rac_addObserverForName:SYSwitchRootViewControllerNotification object:nil] subscribeNext:^(NSNotification * note) {
        /// 这里切换根控制器
        @strongify(self);
        // 重置rootViewController
        SYSwitchRootViewControllerFromType fromType = [note.userInfo[SYSwitchRootViewControllerUserInfoKey] integerValue];
        NSLog(@"fromType is  %zd" , fromType);
        /// 切换根控制器
        SYVM *vm = [self _createInitialViewModel];
        if ([vm isKindOfClass:[SYHomePageVM class]]) {
            [[RCIM sharedRCIM] connectWithToken:self.services.client.currentUser.userToken success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                [MobClick profileSignInWithPUID:userId];
                [Bugly setUserIdentifier:userId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    RCUserInfo *rcUser = [[RCUserInfo alloc]initWithUserId:userId name:self.services.client.currentUser.userName portrait:self.services.client.currentUser.userHeadImg];
                    [RCIM sharedRCIM].currentUserInfo = rcUser;
                    [self.services resetRootViewModel:vm];
                    [MBProgressHUD sy_showTips:@"登录成功"];
                });
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%long", status);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.services resetRootViewModel:vm];
                    [MBProgressHUD sy_showTips:[NSString stringWithFormat:@"连接IM服务器异常%long",status]];
                });
            } tokenIncorrect:^{
                // token永久有效，这种情形应该不会出现
                NSLog(@"token错误");
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.services resetRootViewModel:vm];
            });
        }
    }];
    
    /// 配置H5
//    [SBConfigureManager configure];
}

#pragma mark - 调试(DEBUG)模式下的工具条
- (void)_configDebugModelTools {
#if defined(DEBUG)||defined(_DEBUG)
    /// 显示FPS
    [[JPFPSStatus sharedInstance] open];
#endif
}

#pragma mark - 创建根控制器
- (SYVM *)_createInitialViewModel {
    /// 这里判断一下
    if ([SAMKeychain rawLogin] && self.services.client.currentUser) {
        /// 已经登录，跳转到主页
        return [[SYHomePageVM alloc] initWithServices:self.services params:nil];
    } else {
        /// 进入登录页
        return [[SYLoginVM alloc] initWithServices:self.services params:nil];
    }
}
#pragma mark- 获取appDelegate
+ (SYAppDelegate *)sharedDelegate {
    return (SYAppDelegate *)[[UIApplication sharedApplication] delegate];
}

// 注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

// 上传deviceToekn到融云服务器
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken为:%@",token);
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"error -- %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // userInfo为远程推送的内容
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *msg = (RCInformationNotificationMessage *)message.content;
        SYNotificationModel *model = [SYNotificationModel yy_modelWithJSON:msg.message];
        if ([model.type isEqualToString:@"video"]) {
            SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:@{@"userId":model.senderId}];
            SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_IMINFO parameters:subscript.dictionary];
            [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults] subscribeNext:^(SYUser *user) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [FFToast showToastWithTitle:@"红娘客服" message:model.content iconImage:SYImageNamed(@"header_default_100x100") duration:2 toastType:FFToastTypeDefault];
            });
        }
    }
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    if ([RCIMClient sharedRCIMClient].sdkRunningMode == RCSDKRunningMode_Background && 0 == left.integerValue) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
        dispatch_async(dispatch_get_main_queue(),^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
        });
    }
}

// 监听融云连接状态
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到您的帐号在别的设备上登录，您被迫下线！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 退出融云
                [[RCIMClient sharedRCIMClient] logout];
                // 断开websocket
                [SYSharedAppDelegate stopWebSocketService];
                // 切换至登录页面
                [SAMKeychain setRawLogin:nil];
                // 发送通知进行页面跳转
                [SYNotificationCenter postNotificationName:SYSwitchRootViewControllerNotification object:nil userInfo:@{SYSwitchRootViewControllerUserInfoKey:@(SYSwitchRootViewControllerFromTypeLogout)}];
            });
        }]];
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
        application.applicationIconBadgeNumber = unreadMsgCount;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (!([SAMKeychain rawLogin] == nil)) {
        NSString *url = [NSString stringWithFormat:@"%@?type=1&userId=%@&userPassword=%@",SY_WEB_SOCKET_URL,self.services.client.currentUserId,self.services.client.currentUser.userPassword];
        [self startWebSocketService:url];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([SYSocketManager shareManager].sy_socketStatus == SYSocketStatusConnected || [SYSocketManager shareManager].sy_socketStatus == SYSocketStatusReceived) {
        // 挂断视频并断开websocket
        [SYNotificationCenter postNotificationName:@"HangUpVideo" object:nil];
        [self stopWebSocketService];
    }
}

- (void)presentVC:(UIViewController *)vc withAnimation:(CATransition *)animation {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIWindow *activityWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    activityWindow.windowLevel = UIWindowLevelAlert;
    activityWindow.rootViewController = vc;
    [activityWindow makeKeyAndVisible];
    [[activityWindow layer] addAnimation:animation forKey:nil];
    [_callWindows addObject:activityWindow];
}

- (void)dismissVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[RCCallBaseViewController class]]) {
        UIViewController *rootVC = vc;
        while (rootVC.parentViewController) {
            rootVC = rootVC.parentViewController;
        }
        vc = rootVC;
    }
    for (UIWindow *window in self.callWindows) {
        if (window.rootViewController == vc) {
            [window resignKeyWindow];
            window.hidden = YES;
            [[UIApplication sharedApplication].delegate.window makeKeyWindow];
            [self.callWindows removeObject:window];
            break;
        }
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

// 启动websocket服务
- (void)startWebSocketService:(NSString *)url {
    [[SYSocketManager shareManager] sy_open:url connect:^{
        NSLog(@"connect success");
    } receive:^(id  _Nonnull message, SYSocketReceiveType type) {
        if (type == SYSocketReceiveTypeForMessage) {
            SYSocketResponseModel *response = [SYSocketResponseModel modelWithJSON:message];
            if (response != nil) {
                NSDictionary *params = response.data;
                if (response.code == 0) {
                    if ([params[@"type"] intValue] == 1) {
                        // 登录相关的响应
//                        if ([params[@"isFirst"] intValue] == 1) {
//                            // 首次登录
                        [SYNotificationCenter postNotificationName:@"login" object:@{@"code":@"200"}];
//                        } else {
//                            // 这个时候需要判断
//                            if ([SAMKeychain rawLogin] == nil) {
//                                // 这种情况出现的可能是：主播已经完成了首次信息填充，但是卸载过app导致记录丢失
//                                [SYNotificationCenter postNotificationName:@"login" object:@{@"code":@"288"}];
//                            }
//                        }
                    } else if ([params[@"type"] intValue] == 2){
                        // 开始计费
                        if (params[@"longestMinutes"] != nil) {
                            NSString *time = params[@"longestMinutes"];
                            // 根据服务器返回的时间启动定时器定时挂断视频
                            [SYNotificationCenter postNotificationName:@"HangUpVideo" object:@{@"time":time}];
                        } else {
                            // 为空则立即挂断
                            [SYNotificationCenter postNotificationName:@"HangUpVideo" object:nil];
                        }
                    } else if ([params[@"type"] intValue] == 3){
                        // 结束计费
                        NSLog(@"结束计费：%@",params);
                    } else if ([params[@"type"] intValue] == 4){
                        // 礼物请求
                        [SYNotificationCenter postNotificationName:@"sendGift" object:params];
                    } else if ([params[@"type"] intValue] == 5){
                        // 更新挂断时间
                        NSString *time = params[@"longestMinutes"];
                        [SYNotificationCenter postNotificationName:@"HangUpVideo" object:@{@"time":time}];
                    } else {
                        NSLog(@"%@",params);
                    }
                }
            } else {
                NSLog(@"收到了服务器发来的:%@",message);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD sy_showErrorTips:error];
        if ([error.userInfo[@"HTTPResponseStatusCode"] intValue] == 400) {
            [SYNotificationCenter postNotificationName:@"login" object:@{@"code":@"400"}];
        } else if ([error code] == 504) {
            NSLog(@"与服务器失去连接，正在重连中");
        }
    }];
}

- (void)sendMessageByWebSocketService:(NSString *) message {
    NSLog(@"主动发送了数据:%@",message);
    [[SYSocketManager shareManager] sy_send:message];
}

- (void)stopWebSocketService {
    [[SYSocketManager shareManager] sy_close:^(NSInteger code, NSString * _Nonnull reason, BOOL wasClean) {
        NSLog(@"code:%ld,reason:%@,wasClean:%f",(long)code,reason,wasClean);
    }];
}

// 监来电状态
- (void)registerTelephonyEvent {
    self.callCenter = [[CTCallCenter alloc] init];
    @weakify(self)
    self.callCenter.callEventHandler = ^(CTCall *call) {
        @strongify(self)
        if ([call.callState isEqualToString:CTCallStateIncoming]) {
            // 有电话呼入,断开websocket连接
            [self stopWebSocketService];
        } else if ([call.callState isEqualToString:@"CTCallStateDisconnected"]) {
            // 通话结束或者挂断电话
            if (!([SAMKeychain rawLogin] == nil)) {
                NSString *url = [NSString stringWithFormat:@"%@?type=1&userId=%@&userPassword=%@",SY_WEB_SOCKET_URL,self.services.client.currentUserId,self.services.client.currentUser.userPassword];
                [self startWebSocketService:url];
            }
        }
    };
}

@end
