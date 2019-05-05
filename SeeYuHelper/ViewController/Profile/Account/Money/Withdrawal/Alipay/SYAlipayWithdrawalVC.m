//
//  SYAlipayWithdrawalVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAlipayWithdrawalVC.h"

@interface SYAlipayWithdrawalVC ()

@property (nonatomic, strong) UITextField *moneyNumberTextField;

@property (nonatomic, strong) UIImageView *moneyNumberImageView;

@property (nonatomic, strong) UITextField *realNameTextField;

@property (nonatomic, strong) UIImageView *realNameImageView;

@property (nonatomic, strong) UITextField *alipayAccountTextField;

@property (nonatomic, strong) UIImageView *alipayAccountImageView;

@property (nonatomic, strong) UITextField *contactTextField;

@property (nonatomic, strong) UIImageView *contactImageView;

@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation SYAlipayWithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
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
    realNameTextField.placeholder = @"请输入支付宝实名";
    realNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _realNameTextField = realNameTextField;
    [self.view addSubview:realNameTextField];
    
    UIImageView *realNameImageView = [UIImageView new];
    realNameImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _realNameImageView = realNameImageView;
    [self.view addSubview:realNameImageView];
    
    UITextField *alipayAccountTextField = [UITextField new];
    alipayAccountTextField.placeholder = @"请输入支付宝账号";
    alipayAccountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _alipayAccountTextField = alipayAccountTextField;
    [self.view addSubview:alipayAccountTextField];
    
    UIImageView *alipayAccountImageView = [UIImageView new];
    alipayAccountImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _alipayAccountImageView = alipayAccountImageView;
    [self.view addSubview:alipayAccountImageView];
    
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
    [_alipayAccountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.realNameImageView.mas_bottom).offset(30);
        make.height.offset(30);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [_alipayAccountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alipayAccountTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.alipayAccountTextField).offset(10);
    }];
    [_contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayAccountImageView.mas_bottom).offset(30);
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
