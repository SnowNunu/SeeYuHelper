//
//  SYPasswordModifyVC.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYPasswordModifyVM.h"
#import <CocoaSecurity/CocoaSecurity.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYPasswordModifyVC : SYVC

@property (nonatomic, strong) SYPasswordModifyVM *viewModel;

@end

NS_ASSUME_NONNULL_END
