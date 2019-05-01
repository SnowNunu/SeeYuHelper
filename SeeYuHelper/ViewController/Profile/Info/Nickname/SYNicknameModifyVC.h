//
//  SYNicknameModifyVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYNicknameModifyVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYNicknameModifyVC : SYVC

@property (nonatomic, strong) SYNicknameModifyVM *viewModel;

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, weak) UITextField *textField;

@end

NS_ASSUME_NONNULL_END
