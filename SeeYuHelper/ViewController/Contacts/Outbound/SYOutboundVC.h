//
//  SYOutboundVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/19.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYOutboundVM.h"
#import "JX_GCDTimerManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYOutboundVC : SYVC

@property (nonatomic, strong) SYOutboundVM *viewModel;

@end

NS_ASSUME_NONNULL_END
