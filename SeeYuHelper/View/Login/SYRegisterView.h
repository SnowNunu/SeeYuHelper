//
//  SYRegisterView.h
//  SeeYu
//
//  Created by 唐荣才 on 2018/12/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYRegisterView : UIView 

/// 昵称输入框
@property(nonatomic, weak) UITextField *aliasTextField;

/// 年龄按钮
@property(nonatomic, weak) UIButton *ageBtn;

/// "男"按钮
@property(nonatomic, weak) UIButton *maleBtn;

@property(nonatomic, strong) UITapGestureRecognizer *chooseMaleTap;

/// "男"文本
@property(nonatomic, weak) UILabel *maleLabel;

/// "女"按钮
@property(nonatomic, weak) UIButton *femaleBtn;

@property(nonatomic, strong) UITapGestureRecognizer *chooseFemaleTap;

/// "女"文本
@property(nonatomic, weak) UILabel *femaleLabel;

/// 职业选择框
@property(nonatomic, weak) UIButton *jobBtn;

/// 收入选择框
@property(nonatomic, weak) UIButton *incomeBtn;

/// 身高选择框
@property(nonatomic, weak) UIButton *heightBtn;

/// 婚姻状态选择框
@property(nonatomic, weak) UIButton *maritalStatusBtn;

/// 完成按钮
@property(nonatomic, weak) UIButton *completeBtn;

+ (instancetype)registerView;

@end

NS_ASSUME_NONNULL_END
