//
//  SYAuthenticationVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/13.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYAuthenticationVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAuthenticationVC : SYVC

@property (nonatomic, strong) SYAuthenticationVM *viewModel;

@end

NS_ASSUME_NONNULL_END
