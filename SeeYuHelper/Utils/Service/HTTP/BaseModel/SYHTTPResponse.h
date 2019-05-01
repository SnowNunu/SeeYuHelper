//
//  SYHTTPResponse.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/01/08.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYObject.h"

/// 请求数据返回的状态码
typedef NS_ENUM(NSUInteger, SYHTTPResponseCode) {
    SYHTTPResponseCodeSuccess = 0 ,                     /// 请求成功
    SYHTTPResponseCodeNotLogin = 666,                     /// 用户尚未登录
    SYHTTPResponseCodeParametersVerifyFailure = 105,      /// 参数验证失败
};

@interface SYHTTPResponse : SYObject
/// The parsed SYObject object corresponding to the API response.
/// The developer need care this data 切记：若没有数据是NSNull 而不是nil .对应于服务器json数据的 data
@property (nonatomic, readonly, strong) id parsedResult;
/// 自己服务器返回的状态码 对应于服务器json数据的 code
@property (nonatomic, readonly, assign) SYHTTPResponseCode code;
/// 自己服务器返回的信息 对应于服务器json数据的 code
@property (nonatomic, readonly, copy) NSString *msg;


// Initializes the receiver with the headers from the given response, and given the origin data and the
// given parsed model object(s).
- (instancetype)initWithResponseObject:(id)responseObject parsedResult:(id)parsedResult;
@end
