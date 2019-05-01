//
//  SYBaseInfoEditVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYBaseInfoEditVM.h"
#import "ZYImagePicker.h"
#import "ActionSheetPicker.h"
#import "ActionSheetCustomPicker.h"
#import "SYSignatureVM.h"
#import "SYNicknameModifyVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYBaseInfoEditVC : SYVC

@property (nonatomic, strong) SYBaseInfoEditVM *viewModel;

@end

NS_ASSUME_NONNULL_END
