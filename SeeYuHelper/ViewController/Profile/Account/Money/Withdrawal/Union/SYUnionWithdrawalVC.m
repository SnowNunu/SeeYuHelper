//
//  SYUnionWithdrawalVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYUnionWithdrawalVC.h"

@interface SYUnionWithdrawalVC ()

@property (nonatomic, strong) UITextField *moneyNumberTextField;

@property (nonatomic, strong) UIImageView *moneyNumberImageView;

@property (nonatomic, strong) UITextField *realNameTextField;

@property (nonatomic, strong) UIImageView *realNameImageView;

@property (nonatomic, strong) UITextField *bankCardTextField;

@property (nonatomic, strong) UIImageView *bankCardImageView;

@property (nonatomic, strong) UITextField *bankNameTextField;

@property (nonatomic, strong) UIImageView *bankNameImageView;

@property (nonatomic, strong) UITextField *contactTextField;

@property (nonatomic, strong) UIImageView *contactImageView;

@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation SYUnionWithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [[self.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if ([self.moneyNumberTextField.text stringByTrim].length == 0) {
            [MBProgressHUD sy_showTips:@"请先输入提现金额"];
        } else if ([self.realNameTextField.text stringByTrim].length == 0) {
            [MBProgressHUD sy_showTips:@"请先输入真实姓名"];
        } else if ([self.bankCardTextField.text stringByTrim].length == 0) {
            [MBProgressHUD sy_showTips:@"请先输入银行卡号"];
        } else if ([self.bankNameTextField.text stringByTrim].length == 0) {
            [MBProgressHUD sy_showTips:@"请先输入银行名称"];
        } else if ([self.contactTextField.text stringByTrim].length == 0) {
            [MBProgressHUD sy_showTips:@"请先输入联系方式"];
        } else {
            [self.viewModel.enterUnionConfirmViewCommand execute:@{@"money":[self.moneyNumberTextField.text stringByTrim],@"realname":[self.realNameTextField.text stringByTrim],@"bankcard":[self.bankCardTextField.text stringByTrim],@"bankname":[self.bankNameTextField.text stringByTrim],@"contact":[self.contactTextField.text stringByTrim]}];
        }
    }];
}

- (void)_setupSubViews {
    UITextField *moneyNumberTextField = [UITextField new];
    moneyNumberTextField.placeholder = @"请输入提现金额（元）";
    moneyNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    moneyNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _moneyNumberTextField = moneyNumberTextField;
    [self.view addSubview:moneyNumberTextField];
    
    UIImageView *moneyNumberImageView = [UIImageView new];
    moneyNumberImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _moneyNumberImageView = moneyNumberImageView;
    [self.view addSubview:moneyNumberImageView];
    
    UITextField *realNameTextField = [UITextField new];
    realNameTextField.placeholder = @"请输入银行卡实名";
    realNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _realNameTextField = realNameTextField;
    [self.view addSubview:realNameTextField];
    
    UIImageView *realNameImageView = [UIImageView new];
    realNameImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _realNameImageView = realNameImageView;
    [self.view addSubview:realNameImageView];
    
    UITextField *bankCardTextField = [UITextField new];
    bankCardTextField.placeholder = @"请输入银行卡账号";
    bankCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    bankCardTextField.keyboardType = UIKeyboardTypeNumberPad;
    _bankCardTextField = bankCardTextField;
    [self.view addSubview:bankCardTextField];
    
    UIImageView *bankCardImageView = [UIImageView new];
    bankCardImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _bankCardImageView = bankCardImageView;
    [self.view addSubview:bankCardImageView];
    
    UITextField *bankNameTextField = [UITextField new];
    bankNameTextField.placeholder = @"请输入银行名称";
    bankNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    bankNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _bankNameTextField = bankNameTextField;
    [self.view addSubview:bankNameTextField];
    
    UIImageView *bankNameImageView = [UIImageView new];
    bankNameImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _bankNameImageView = bankNameImageView;
    [self.view addSubview:bankNameImageView];
    
    UITextField *contactTextField = [UITextField new];
    contactTextField.placeholder = @"请输入联系方式";
    contactTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    contactTextField.keyboardType = UIKeyboardTypePhonePad;
    _contactTextField = contactTextField;
    [self.view addSubview:contactTextField];
    
    UIImageView *contactImageView = [UIImageView new];
    contactImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _contactImageView = contactImageView;
    [self.view addSubview:contactImageView];
    
    UIButton *nextBtn = [UIButton new];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = SYRegularFont(18);
    nextBtn.backgroundColor = SYColor(159, 105, 235);
    _nextBtn = nextBtn;
    [self.view addSubview:nextBtn];
}

- (void)_makeSubViewsConstraints {
    [_moneyNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.height.offset(30);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [_moneyNumberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.moneyNumberTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.moneyNumberTextField).offset(10);
    }];
    [_realNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyNumberImageView.mas_bottom).offset(30);
        make.height.offset(30);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [_realNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.realNameTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.realNameTextField).offset(10);
    }];
    [_bankCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.realNameImageView.mas_bottom).offset(30);
        make.height.offset(30);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [_bankCardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bankCardTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.bankCardTextField).offset(10);
    }];
    [_bankNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankCardImageView.mas_bottom).offset(30);
        make.height.offset(30);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [_bankNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bankNameTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.bankNameTextField).offset(10);
    }];
    [_contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNameImageView.mas_bottom).offset(30);
        make.height.offset(30);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [_contactImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contactTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.contactTextField).offset(10);
    }];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.width.left.equalTo(self.view);
        make.height.offset(50);
    }];
}

@end
