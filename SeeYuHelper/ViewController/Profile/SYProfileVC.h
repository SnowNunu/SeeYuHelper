//
//  SYProfileVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYProfileVM.h"
#import "SYSigninVC.h"
#import "SYSigninVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYProfileVC : SYVC

@property (nonatomic, strong) SYProfileVM *viewModel;

@end

NS_ASSUME_NONNULL_END
