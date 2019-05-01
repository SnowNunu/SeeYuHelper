//
//  SYSocketManager.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSocketManager.h"
#import "SRWebSocket.h"

#define dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

@interface SYSocketManager () <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocket;

@property (nonatomic, assign) SYSocketStatus sy_socketStatus;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, weak) NSTimer *heartBeat;

@property (nonatomic, copy) NSString *urlString;

@end

@implementation SYSocketManager {
    NSInteger _reconnectCounter;
}


+ (instancetype)shareManager {
    static SYSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.overtime = 1;
        instance.reconnectCount = 5;
    });
    return instance;
}

- (void)sy_open:(NSString *)urlStr connect:(SYSocketDidConnectBlock)connect receive:(SYSocketDidReceiveBlock)receive failure:(SYSocketDidFailBlock)failure {
    [SYSocketManager shareManager].connect = connect;
    [SYSocketManager shareManager].receive = receive;
    [SYSocketManager shareManager].failure = failure;
    [self sy_open:urlStr];
}

- (void)sy_close:(SYSocketDidCloseBlock)close {
    [SYSocketManager shareManager].close = close;
    [self sy_close];
}

// Send a UTF8 String or Data.
- (void)sy_send:(id)data {
    switch ([SYSocketManager shareManager].sy_socketStatus) {
        case SYSocketStatusConnected:
        case SYSocketStatusReceived: {
            NSLog(@"发送中。。。");
            [self.webSocket send:data];
            break;
        }
        case SYSocketStatusFailed:
            NSLog(@"发送失败");
            break;
        case SYSocketStatusClosedByServer:
            NSLog(@"已经关闭");
            break;
        case SYSocketStatusClosedByUser:
            NSLog(@"已经关闭");
            break;
    }
}

#pragma mark -- private method
- (void)sy_open:(id)params {
    //    NSLog(@"params = %@",params);
    NSString *urlStr = nil;
    if ([params isKindOfClass:[NSString class]]) {
        urlStr = (NSString *)params;
    } else if([params isKindOfClass:[NSTimer class]]) {
        NSTimer *timer = (NSTimer *)params;
        urlStr = [timer userInfo];
    }
    [SYSocketManager shareManager].urlString = urlStr;
    [self.webSocket close];
    self.webSocket.delegate = nil;
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webSocket.delegate = self;
    
    [self.webSocket open];
}

- (void)sy_close {
    [self.webSocket close];
    self.webSocket = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)sy_reconnect {
    // 计数+1
    if (_reconnectCounter < self.reconnectCount - 1) {
        _reconnectCounter ++;
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(sy_open:) userInfo:self.urlString repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    } else {
        NSLog(@"Websocket Reconnected Outnumber ReconnectCount");
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        return;
    }
}

#pragma mark -- SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Websocket Connected");
    [SYSocketManager shareManager].connect ? [SYSocketManager shareManager].connect() : nil;
    [SYSocketManager shareManager].sy_socketStatus = SYSocketStatusConnected;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
    [self initHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@":( Websocket Failed With Error %@", error);
    [SYSocketManager shareManager].sy_socketStatus = SYSocketStatusFailed;
    [SYSocketManager shareManager].failure ? [SYSocketManager shareManager].failure(error) : nil;
    // 重连
    [self sy_reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@":( Websocket Receive With message %@", message);
    [SYSocketManager shareManager].sy_socketStatus = SYSocketStatusReceived;
    if ([message isEqualToString:@"PONG"]) {
        [SYSocketManager shareManager].receive ? [SYSocketManager shareManager].receive(message,SYSocketReceiveTypeForPong) : nil;
    } else {
        [SYSocketManager shareManager].receive ? [SYSocketManager shareManager].receive(message,SYSocketReceiveTypeForMessage) : nil;
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Closed Reason:%@  code = %zd",reason,code);
    if (reason) {
        [SYSocketManager shareManager].sy_socketStatus = SYSocketStatusClosedByServer;
        // 重连
        [self sy_reconnect];
    } else {
        [SYSocketManager shareManager].sy_socketStatus = SYSocketStatusClosedByUser;
    }
    [SYSocketManager shareManager].close ? [SYSocketManager shareManager].close(code,reason,wasClean) : nil;
    self.webSocket = nil;
    [self destoryHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"收到pong");
    [SYSocketManager shareManager].receive ? [SYSocketManager shareManager].receive(pongPayload,SYSocketReceiveTypeForPong) : nil;
}

- (void)dealloc {
    // Close WebSocket
    [self sy_close];
}

//初始化心跳
- (void)initHeartBeat {
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        __weak typeof(self) weakSelf = self;
        //心跳设置为3分钟，NAT超时一般为5分钟
        self.heartBeat = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
            [weakSelf sy_send:@"PING"];
        }];
        [[NSRunLoop currentRunLoop]addTimer:self.heartBeat forMode:NSRunLoopCommonModes];
    })
}

//取消心跳
- (void)destoryHeartBeat {
    dispatch_main_async_safe(^{
        if (self.heartBeat) {
            [self.heartBeat invalidate];
            self.heartBeat = nil;
        }
    })
}

//pingPong
- (void)sy_ping {
    if ([SYSocketManager shareManager].sy_socketStatus == SYSocketStatusConnected) {
        [self.webSocket sendPing:nil];
    }
}

@end

