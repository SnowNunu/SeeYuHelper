//
//  SYHTTPServiceConstant.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#ifndef SYHTTPServiceConstant_h
#define SYHTTPServiceConstant_h

/// 服务器相关
#define SYHTTPRequestTokenKey @"token"

/// 私钥key
#define SYHTTPServiceKey  @"privatekey"
/// 私钥Value
#define SYHTTPServiceKeyValue @"/** 你的私钥 **/"

/// 签名key
#define SYHTTPServiceSignKey @"sign"

/// 服务器返回的三个固定字段
/// 状态码key
#define SYHTTPServiceResponseCodeKey @"code"
/// 消息key
#define SYHTTPServiceResponseMsgKey    @"msg"
/// 数据data
#define SYHTTPServiceResponseDataKey   @"data"
/// 数据data{"list":[]}
#define SYHTTPServiceResponseDataListKey   @"list"

#endif /* SYHTTPServiceConstant_h */
