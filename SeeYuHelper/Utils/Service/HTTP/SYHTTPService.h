//
//  SYHTTPService.h
//  WeChat
//
//  Created by senba on 2017/10/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager+RACSupport.h"
#import "RACSubscriber+AFProgressCallbacks.h"
#import "SYHTTPRequest.h"
#import "SYHTTPResponse.h"
#import "SYURLConfigure.h"
#import "SYUser.h"


// The domain for all errors originating in SYHTTPService.
FOUNDATION_EXTERN NSString *const SYHTTPServiceErrorDomain ;
///
FOUNDATION_EXTERN NSString *const SYHTTPServiceErrorHTTPPResponseStatusCodeKey;
FOUNDATION_EXTERN NSString *const SYHTTPServiceErrorHTTPPResponseMsgKey ;

// A user info key associated with the NSURL of the request that failed.
FOUNDATION_EXTERN NSString * const SYHTTPServiceErrorRequestURLKey ;
// A user info key associated with an NSNumber, indicating the HTTP status code
// that was returned with the error.
FOUNDATION_EXTERN NSString * const SYHTTPServiceErrorHTTPStatusCodeKey ;
/// The descriptive message returned from the API, e.g., "Validation Failed".
FOUNDATION_EXTERN NSString * const SYHTTPServiceErrorDescriptionKey ;
/// An array of specific message strings returned from the API, e.g.,
/// "No commits between joshaber:master and joshaber:feature".
FOUNDATION_EXTERN NSString * const SYHTTPServiceErrorMessagesKey ;





/// 连接服务器失败 default
FOUNDATION_EXTERN NSInteger const SYHTTPServiceErrorConnectionFailed ;

FOUNDATION_EXTERN NSInteger const SYHTTPServiceErrorJSONParsingFailed ;
// The request was invalid (HTTP error 400).
FOUNDATION_EXTERN NSInteger const SYHTTPServiceErrorBadRequest ;
// The server is refusing to process the request because of an
// authentication-related issue (HTTP error 403).
//
// Often, this means that there have been too many failed attempts to
// authenticate. Even a successful authentication will not work while this error
// code is being returned. The only recourse is to stop trying and wait for
// a bit.
FOUNDATION_EXTERN NSInteger const SYHTTPServiceErrorRequestForbidden ;
// The server refused to process the request (HTTP error 422)
FOUNDATION_EXTERN NSInteger const SYHTTPServiceErrorServiceRequestFailed ;
// There was a problem establishing a secure connection, although the server is
// reachable.
FOUNDATION_EXTERN NSInteger const SYHTTPServiceErrorSecureConnectionFailed ;


/// 用户数据配置完成
FOUNDATION_EXTERN NSString *const SBUserDataConfigureCompleteNotification;
/// 用户数据配置完成，取出userInfo 数据的的key
FOUNDATION_EXTERN NSString *const SBUserDataConfigureCompleteUserInfoKey;

@interface SYHTTPService : AFHTTPSessionManager
/// 单例
+(instancetype) sharedInstance;

/// 存储用户
- (void)saveUser:(SYUser *)user;

/// 删除用户
- (void)deleteUser:(SYUser *)user;

/// 获取当前用户
- (SYUser *)currentUser;

/// 获取当前用户的id
- (NSString *)currentUserId;

/// 用户信息配置完成
- (void)postUserDataConfigureCompleteNotification;

/// 是否登录
- (BOOL)isLogin;

/// 用户登录
- (void)loginUser:(SYUser *)user;

/// 退出登录
- (void)logoutUser;
@end


/// 请求类
@interface SYHTTPService (Request)

/// 1. 使用须知：后台返回数据的保证为👇固定格式 且`data:{}`必须为`字典`或者`NSNull`;
/// {
///    code：0,
///    msg: "",
///    data:{
///    }
/// }
/// 这个方法返回的 signal 将会 send `SYHTTPResponse`这个实例，`parsedResult`就是对应键data对应的值， 如果你想获得里面的parsedResult实例，请使用以下方法
/// [[self enqueueRequest:request resultClass:SBUser.class] sb_parsedResults];
/// 这样取出来的就是 SBUser对象

/// 2.使用方法如下
/*
 /// 1. 配置参数
 SBKeyedSubscript *subscript = [SBKeyedSubscript subscript];
 subscript[@"page"] = @1;
 
 /// 2. 配置参数模型
 SBURLParameters *paramters = [SBURLParameters urlParametersWithMethod:@"GET" path:SUProduct parameters:subscript.dictionary];
 
 /// 3. 创建请求
 /// 3.1 resultClass 传入对象必须得是 SYObject的子类
 /// 3.2 resultClass 传入nil ，那么回调回来的值就是，服务器返回来的数据
 [[[[SYHTTPRequest requestWithParameters:paramters]
 enqueueResultClass:[SBGoodsData class]]
 sb_parsedResults]
 subscribeNext:^(SBGoodsData * goodsData) {
 /// 成功回调
 
 } error:^(NSError *error) {
 /// 失败回调
 
 } completed:^{
 /// 完成
 
 }];
 
 */

/**
 Enqueues a request to be sent to the server.
 This will automatically fetch a of the given endpoint. Each object
 from each page will be sent independently on the returned signal, so
 subscribers don't have to know or care about this pagination behavior.
 
 @param request config the request
 @param resultClass A subclass of `SYObject` that the response data should be returned as,
 and will be accessible from the `parsedResult`
 @return Returns a signal which will send an instance of `SYHTTPResponse` for each parsed
 JSON object, then complete. If an error occurs at any point,
 the returned signal will send it immediately, then terminate.
 */
-(RACSignal *)enqueueRequest:(SYHTTPRequest *) request
                 resultClass:(Class /*subclass of SYObject*/) resultClass;


/**
 用来上传多个文件流，也可以上传单个文件
 
 @param request SYHTTPRequest
 @param resultClass 要转化出来的请求结果且必须是 `SYObject`的子类，否则Crash
 @param fileDatas 要上传的 文件数据，数组里面必须是装着` NSData ` 否则Crash
 @param name  这个是服务器的`资源文件名`，这个服务器会给出具体的数值，不能传nil 否则 Crach
 @param mimeType http://www.jianshu.com/p/a3e77751d37c 如果传nil ，则会传递 application/octet-stream
 @return Returns a signal which will send an instance of `SYHTTPResponse` for each parsed
 JSON object, then complete. If an error occurs at any point,
 the returned signal will send it immediately, then terminate.
 */
- (RACSignal *)enqueueUploadRequest:(SYHTTPRequest *) request
                        resultClass:(Class /*subclass of SYObject*/) resultClass
                          fileDatas:(NSArray <NSData *> *)fileDatas
                               name:(NSString *)name
                           mimeType:(NSString *)mimeType;

/**
 用来上传多个文件流，也可以上传单个文件
 这个方法要求上传的文件流和文件流名称需要相同数量
 @param request SYHTTPRequest
 @param resultClass 要转化出来的请求结果且必须是 `SYObject`的子类，否则Crash
 @param fileDatas 要上传的 文件数据，数组里面必须是装着` NSData ` 否则Crash
 @param name  这个是服务器的`资源文件名`，这个服务器会给出具体的数值，不能传nil 否则 Crach
 @param mimeType http://www.jianshu.com/p/a3e77751d37c 如果传nil ，则会传递 application/octet-stream
 @return Returns a signal which will send an instance of `SYHTTPResponse` for each parsed
 JSON object, then complete. If an error occurs at any point,
 the returned signal will send it immediately, then terminate.
 这个方法与上面方法的区别是：多个图片上传时名字也由用户自定义
 */
#pragma mark - 多图片上传
- (RACSignal *)enqueueUploadRequest:(SYHTTPRequest *)request resultClass:(Class)resultClass fileDatas:(NSArray<NSData *> *)fileDatas namesArray:(NSArray<NSString *> *)nameArrays mimeType:(NSString *)mimeType;
@end
