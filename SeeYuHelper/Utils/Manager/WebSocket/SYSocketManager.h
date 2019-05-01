//
//  SYSocketManager.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/26.
//  Copyright © 2019 fljj. All rights reserved.
//  参照别人项目修改的websocket连接类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  socket状态
 */
typedef NS_ENUM(NSInteger,SYSocketStatus){
    SYSocketStatusConnected,// 已连接
    SYSocketStatusFailed,// 失败
    SYSocketStatusClosedByServer,// 系统关闭
    SYSocketStatusClosedByUser,// 用户关闭
    SYSocketStatusReceived// 接收消息
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger,SYSocketReceiveType){
    SYSocketReceiveTypeForMessage,  // 普通消息
    SYSocketReceiveTypeForPong      // 心跳消息
};

/**
 *  连接成功回调
 */
typedef void(^SYSocketDidConnectBlock)();

/**
 *  失败回调
 */
typedef void(^SYSocketDidFailBlock)(NSError *error);

/**
 *  关闭回调
 */
typedef void(^SYSocketDidCloseBlock)(NSInteger code,NSString *reason,BOOL wasClean);

/**
 *  消息接收回调
 */
typedef void(^SYSocketDidReceiveBlock)(id message ,SYSocketReceiveType type);

@interface SYSocketManager : NSObject

/**
 *  连接回调
 */
@property (nonatomic,copy) SYSocketDidConnectBlock connect;

/**
 *  接收消息回调
 */
@property (nonatomic,copy) SYSocketDidReceiveBlock receive;

/**
 *  失败回调
 */
@property (nonatomic,copy) SYSocketDidFailBlock failure;

/**
 *  关闭回调
 */
@property (nonatomic,copy) SYSocketDidCloseBlock close;

/**
 *  当前的socket状态
 */
@property (nonatomic,assign,readonly) SYSocketStatus sy_socketStatus;

/**
 *  超时重连时间，默认1秒
 */
@property (nonatomic,assign) NSTimeInterval overtime;

/**
 *  重连次数,默认5次
 */
@property (nonatomic, assign)NSUInteger reconnectCount;

/**
 *  单例调用
 */
+ (instancetype)shareManager;

/**
 *  开启socket
 *
 *  @param urlStr  服务器地址
 *  @param connect 连接成功回调
 *  @param receive 接收消息回调
 *  @param failure 失败回调
 */
- (void)sy_open:(NSString *)urlStr connect:(SYSocketDidConnectBlock)connect receive:(SYSocketDidReceiveBlock)receive failure:(SYSocketDidFailBlock)failure;

/**
 *  关闭socket
 *
 *  @param close 关闭回调
 */
- (void)sy_close:(SYSocketDidCloseBlock)close;

/**
 *  发送消息，NSString 或者 NSData
 *
 *  @param data Send a UTF8 String or Data.
 */
- (void)sy_send:(id)data;

@end

NS_ASSUME_NONNULL_END
