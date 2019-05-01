//
//  SYRegisterVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2017/9/26.
//  Copyright © 2019年 fljj. All rights reserved.

#import "SYVC.h"
#import "SYRegisterVM.h"
#import "SYRegisterView.h"
#import "ActionSheetPicker.h"

@interface SYRegisterVC : SYVC

@property(nonatomic, weak) SYRegisterView *registerView;

@property(nonatomic, strong) SYRegisterVM *viewModel;

@end
