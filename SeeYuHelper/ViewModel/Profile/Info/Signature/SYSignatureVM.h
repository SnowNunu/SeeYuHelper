//
//  SYSignatureVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSignatureVM : SYVM

// 签名
@property (nonatomic, strong) NSString *signature;

// 取消
@property (nonatomic, strong) RACCommand *cancelCommand;

// 完成
@property (nonatomic, strong) RACCommand *completeCommand;

// 完成按钮有效性
@property (nonatomic, strong) RACSignal *validCompleteSignal;

@end

NS_ASSUME_NONNULL_END
