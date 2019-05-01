//
//  SYViewModelServices.h
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  视图模型服务层测协议 （导航栏操作的服务层 + 网络的服务层 ）

#import <Foundation/Foundation.h>
#import "SYNavigationProtocol.h"
#import "SYHTTPService.h"
@protocol SYViewModelServices <NSObject,SYNavigationProtocol>
/// A reference to SYHTTPService instance.
/// 全局通过这个Client来请求数据，处理用户信息
@property (nonatomic, readonly, strong) SYHTTPService *client;
@end
