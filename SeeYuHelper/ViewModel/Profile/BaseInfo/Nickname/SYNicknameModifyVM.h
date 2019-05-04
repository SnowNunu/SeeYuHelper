//
//  SYNicknameModifyVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYNicknameModifyVM : SYVM

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) RACCommand *cancelCommand;

@property (nonatomic, strong) RACCommand *completeCommand;

@property (nonatomic, strong) RACSignal *validCompleteSignal;

@end

NS_ASSUME_NONNULL_END
