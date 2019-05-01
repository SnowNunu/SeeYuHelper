//
//  SYLoginVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYLoginVC.h"

@interface SYLoginVC ()

// 手机号输入框
@property (nonatomic, strong) UITextField *mobileTextField;

// 验证码输入框
@property (nonatomic, strong) UITextField *authCodeTextField;

// 获取验证码按钮
@property (nonatomic, strong) CountDownButton *authCodeBtn;

// 登录按钮
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation SYLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupNavigationItem];
    [self _setupSubViews];
}

- (void)_setupNavigationItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:@"注册" titleColor:nil imageName:nil target:nil selector:nil textType:YES];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.enterRegisterViewCommand;
}

- (void)bindViewModel {
    [super bindViewModel];
    [[self.authCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.mobileTextField.text.length == 0) {
            [MBProgressHUD sy_showError:@"请先输入手机号"];
            return;
        }
        if (![NSString sy_isValidMobile:self.mobileTextField.text]) {
            [MBProgressHUD sy_showError:@"请输入正确的手机号"];
            return;
        }
        NSDictionary *parameters = @{@"userMobile":self.mobileTextField.text,@"type":@"1"};
        [self.viewModel.getAuthCodeCommand execute:parameters];
    }];
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.mobileTextField.text.length == 0) {
            [MBProgressHUD sy_showError:@"请先输入手机号"];
            return;
        }
        if (![NSString sy_isValidMobile:self.mobileTextField.text]) {
            [MBProgressHUD sy_showError:@"请输入正确的手机号"];
            return;
        }
        if (self.authCodeTextField.text.length == 0) {
            [MBProgressHUD sy_showError:@"请先输入验证码"];
            return;
        }
        NSDictionary *parameters = @{@"userMobile":self.mobileTextField.text,@"PIN":self.authCodeTextField.text};
        [self.viewModel.loginCommand execute:parameters];
    }];
    [[[self.viewModel.getAuthCodeCommand.executionSignals switchToLatest] deliverOnMainThread] subscribeNext:^(id x) {
        [MBProgressHUD sy_showTips:@"验证码已下发，请留意"];
        [self.authCodeBtn startCountDownWithTotalTime:120 countDowning:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            self.authCodeBtn.userInteractionEnabled = NO;
            NSInteger totoalSecond = day * 24 * 60 * 60 + hour * 60 * 60 + minute * 60 + second;
            [self.authCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发",totoalSecond] forState:UIControlStateNormal];
        } countDownFinished:^(NSTimeInterval leftTime) {
            self.authCodeBtn.userInteractionEnabled = YES;
            [self.authCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        } waitingBlock:^{
            [self.authCodeBtn setTitle:@"等待中.." forState:UIControlStateNormal];
        }];
    }];
    [self.viewModel.getAuthCodeCommand.errors subscribeNext:^(NSError *error) {
        if ([error code] == 78) {
            [MBProgressHUD sy_showTips:@"该手机号尚未注册，请先注册"];
            [self.viewModel.enterRegisterViewCommand execute:nil];
        } else {
            [MBProgressHUD sy_showError:@"服务器异常，请联系客服"];
        }
    }];
    [self.viewModel.loginCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        /// 存储登录账号
        [SAMKeychain setRawLogin:user.userId];
        /// 存储用户数据
        [self.viewModel.services.client loginUser:user];
        /// 切换根控制器
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 发通知
            [MBProgressHUD sy_hideHUD];
            [MBProgressHUD sy_showProgressHUD:@"登录成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SYSwitchRootViewControllerNotification object:nil userInfo:@{SYSwitchRootViewControllerUserInfoKey:@(SYSwitchRootViewControllerFromTypeLogin)}];
        });
    }];
    [self.viewModel.loginCommand.errors subscribeNext:^(NSError *error) {
        if ([error code] == 80) {
            [MBProgressHUD sy_showTips:@"验证码不正确，请检查"];
        }
    }];
}

#pragma mark - 设置子控件
- (void)_setupSubViews {
    UILabel *mobileLabel = [UILabel new];
    mobileLabel.text = @"手机号";
    mobileLabel.textColor = SYColor(153, 153, 153);
    mobileLabel.font = SYRegularFont(18);
    [self.view addSubview:mobileLabel];
    
    UITextField *mobileTextField = [UITextField new];
    mobileTextField.font = SYRegularFont(20);
    mobileTextField.textColor = SYColor(51, 51, 51);
    _mobileTextField = mobileTextField;
    [self.view addSubview:mobileTextField];
    
    UIImageView *line1 = [UIImageView new];
    line1.backgroundColor = SYColor(153, 153, 153);
    [self.view addSubview:line1];
    
    UILabel *authCodeLabel = [UILabel new];
    authCodeLabel.text = @"验证码";
    authCodeLabel.textColor = SYColor(153, 153, 153);
    authCodeLabel.font = SYRegularFont(18);
    [self.view addSubview:authCodeLabel];
    
    UITextField *authCodeTextField = [UITextField new];
    authCodeTextField.font = SYRegularFont(20);
    authCodeTextField.textColor = SYColor(51, 51, 51);
    _authCodeTextField = authCodeTextField;
    [self.view addSubview:authCodeTextField];
    
    _authCodeBtn = [[CountDownButton alloc] initWithKeyInfo:@"authCode"];
    [_authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _authCodeBtn.titleLabel.font = SYRegularFont(15);
    [_authCodeBtn setTitleColor:SYColor(159, 105, 235) forState:UIControlStateNormal];
    _authCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:_authCodeBtn];
    
    UIButton *loginBtn = [UIButton new];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = SYRegularFont(20);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = SYColor(159, 105, 235);
    loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    
    UIImageView *line2 = [UIImageView new];
    line2.backgroundColor = SYColor(153, 153, 153);
    [self.view addSubview:line2];
    
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(45);
        make.height.offset(20);
        make.width.offset(55);
        make.top.equalTo(self.view).offset(45);
    }];
    [mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileLabel.mas_right).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-45);
        make.top.height.equalTo(mobileLabel);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileLabel);
        make.right.equalTo(mobileTextField);
        make.height.offset(1);
        make.top.equalTo(mobileLabel.mas_bottom).offset(15);
    }];
    [authCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.equalTo(mobileLabel);
        make.top.equalTo(line1).offset(30);
    }];
    [authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(authCodeLabel.mas_right).offset(30);
        make.right.equalTo(self.authCodeBtn.mas_left);
        make.top.height.equalTo(authCodeLabel);
    }];
    [self.authCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-45);
        make.height.top.equalTo(authCodeLabel);
        make.width.offset(100);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(authCodeLabel);
        make.right.equalTo(self.authCodeBtn);
        make.height.offset(1);
        make.top.equalTo(authCodeLabel.mas_bottom).offset(15);
    }];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
}

@end
