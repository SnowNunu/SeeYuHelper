//
//  SYMobileBindingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/13.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMobileBindingVC.h"
#import "CountdownButton.h"

@interface SYMobileBindingVC ()

@property (nonatomic, strong) UIView *mobileBgView;

@property (nonatomic, strong) UILabel *mobileLabel;

@property (nonatomic, strong) UITextField *mobileTextField;

@property (nonatomic, strong) UIImageView *underlineImageView;

@property (nonatomic, strong) UITextField *smsCodeTextField;

@property (nonatomic, strong) CountDownButton *authCodeBtn;

@property (nonatomic, strong) UIButton *bindBtn;

@property (nonatomic, strong) UIView *mobileRightsView;

@property (nonatomic, strong) UILabel *mobileRightsLabel;

@property (nonatomic, strong) UILabel *mobileRightsDetailLabel;

@property (nonatomic, strong) UIView *mobileProblemView;

@property (nonatomic, strong) UILabel *mobileProblemLabel;

@property (nonatomic, strong) UILabel *mobileProblemDetailLabel;

@end

@implementation SYMobileBindingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
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
        NSDictionary *parameters = @{@"userMobile":self.mobileTextField.text,@"type":@"2"};
        [self.viewModel.getAuthCodeCommand execute:parameters];
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
        [MBProgressHUD sy_showErrorTips:error];
    }];
    [[self.bindBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.mobileTextField.text.length == 0) {
            [MBProgressHUD sy_showError:@"请先输入手机号"];
            return;
        }
        if (![NSString sy_isValidMobile:self.mobileTextField.text]) {
            [MBProgressHUD sy_showError:@"请输入正确的手机号"];
            return;
        }
        if (self.smsCodeTextField.text.length == 0) {
            [MBProgressHUD sy_showError:@"请先输入验证码"];
            return;
        }
        NSDictionary *parameters = @{@"userMobile":self.mobileTextField.text,@"PIN":self.smsCodeTextField.text,@"userId":self.viewModel.services.client.currentUser.userId};
        [self.viewModel.bindCommand execute:parameters];
    }];
    [self.viewModel.bindCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showProgressHUD:@"绑定成功"];
        [self.viewModel.services popViewModelAnimated:YES];
    }];
    [self.viewModel.bindCommand.errors subscribeNext:^(NSError *error) {
        if ([error code] == 80) {
            [MBProgressHUD sy_showTips:@"验证码不正确，请检查"];
        } else {
            [MBProgressHUD sy_showErrorTips:error];
        }
    }];
}

- (void)_setupSubViews {
    self.view.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    UIView *mobileBgView = [UIView new];
    mobileBgView.backgroundColor = [UIColor whiteColor];
    _mobileBgView = mobileBgView;
    [self.view addSubview:mobileBgView];
    
    UILabel *mobileLabel = [UILabel new];
    mobileLabel.textColor = SYColor(51, 51, 51);
    mobileLabel.font = SYRegularFont(16);
    mobileLabel.textAlignment = NSTextAlignmentLeft;
    mobileLabel.text = @"+86";
    _mobileLabel = mobileLabel;
    [mobileBgView addSubview:mobileLabel];
    
    UITextField *mobileTextField = [UITextField new];
    mobileTextField.placeholder = @"请输入手机号";
    mobileTextField.textAlignment = NSTextAlignmentLeft;
    mobileTextField.font = SYRegularFont(14);
    _mobileTextField = mobileTextField;
    [mobileBgView addSubview:mobileTextField];
    
    UIImageView *underlineImageView = [UIImageView new];
    underlineImageView.backgroundColor = SYColor(153, 153, 153);
    _underlineImageView = underlineImageView;
    [mobileBgView addSubview:underlineImageView];
    
    UITextField *smsCodeTextField = [UITextField new];
    smsCodeTextField.placeholder = @"请输入短信验证码";
    smsCodeTextField.textAlignment = NSTextAlignmentLeft;
    smsCodeTextField.font = SYRegularFont(14);
    _smsCodeTextField = smsCodeTextField;
    [mobileBgView addSubview:smsCodeTextField];
    
    CountDownButton *authCodeBtn = [[CountDownButton alloc] initWithKeyInfo:@"authCode"];
    [authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    authCodeBtn.titleLabel.font = SYRegularFont(12);
    [authCodeBtn setTitleColor:SYColor(159, 105, 235) forState:UIControlStateNormal];
    authCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _authCodeBtn = authCodeBtn;
    [mobileBgView addSubview:authCodeBtn];
    
    UIButton *bindBtn = [UIButton new];
    bindBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    bindBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bindBtn.titleLabel.font = SYRegularFont(18);
    bindBtn.layer.cornerRadius = 5.f;
    bindBtn.layer.masksToBounds = YES;
    _bindBtn = bindBtn;
    [self.view addSubview:bindBtn];
    
    UIView *mobileRightsView = [UIView new];
    mobileRightsView.backgroundColor = [UIColor whiteColor];
    _mobileRightsView = mobileRightsView;
    [self.view addSubview:mobileRightsView];
    
    UILabel *mobileRightsLabel = [UILabel new];
    mobileRightsLabel.textColor = SYColor(51, 51, 51);
    mobileRightsLabel.font = SYRegularFont(13);
    mobileRightsLabel.textAlignment = NSTextAlignmentLeft;
    mobileRightsLabel.text = @"绑定手机可获得以下特权";
    _mobileRightsLabel = mobileRightsLabel;
    [mobileRightsView addSubview:mobileRightsLabel];
    
    UILabel *mobileRightsDetailLabel = [UILabel new];
    mobileRightsDetailLabel.textColor = SYColor(153, 153, 153);
    mobileRightsDetailLabel.font = SYRegularFont(12);
    mobileRightsDetailLabel.text = @"1.绑定手机号码，账号更安全。\n2.账号支持手机号码登录。\n3.VIP用户可以获得专属的VIP客服提供帮助。";
    mobileRightsDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    mobileRightsDetailLabel.numberOfLines = 0;
    _mobileRightsDetailLabel = mobileRightsDetailLabel;
    [mobileRightsView addSubview:mobileRightsDetailLabel];
    
    UIView *mobileProblemView = [UIView new];
    mobileProblemView.backgroundColor = [UIColor whiteColor];
    _mobileProblemView = mobileProblemView;
    [self.view addSubview:mobileProblemView];
    
    UILabel *mobileProblemLabel = [UILabel new];
    mobileProblemLabel.textColor = SYColor(51, 51, 51);
    mobileProblemLabel.font = SYRegularFont(13);
    mobileProblemLabel.textAlignment = NSTextAlignmentLeft;
    mobileProblemLabel.text = @"绑定或使用过程中遇到问题可随时联系我们";
    _mobileProblemLabel = mobileProblemLabel;
    [mobileProblemView addSubview:mobileProblemLabel];
    
    UILabel *mobileProblemDetailLabel = [UILabel new];
    mobileProblemDetailLabel.textColor = SYColor(153, 153, 153);
    mobileProblemDetailLabel.font = SYRegularFont(12);
    mobileProblemDetailLabel.text = @"客服电话：18969706073（09:00-18:00）";
    mobileProblemDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    mobileProblemDetailLabel.numberOfLines = 0;
    _mobileProblemDetailLabel = mobileProblemDetailLabel;
    [mobileProblemView addSubview:mobileProblemDetailLabel];
}

- (void)_makeSubViewsConstraints {
    [_mobileBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.offset(90);
    }];
    [_mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileBgView).offset(15);
        make.height.offset(20);
        make.top.equalTo(self.mobileBgView).offset(12.5);
        make.width.offset(30);
    }];
    [_mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileLabel.mas_right).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.centerY.equalTo(self.mobileLabel);
    }];
    [_underlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.height.offset(1);
        make.top.equalTo(self.mobileLabel.mas_bottom).offset(12.5);
    }];
    [_smsCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileBgView).offset(15);
        make.right.equalTo(self.authCodeBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.authCodeBtn);
        make.height.offset(20);
    }];
    [_authCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.width.offset(65);
        make.height.offset(25);
        make.bottom.equalTo(self.mobileBgView).offset(-10);
    }];
    [_bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileBgView.mas_bottom).offset(15);
        make.height.offset(40);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    [_mobileRightsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(125);
        make.left.width.equalTo(self.view);
        make.top.equalTo(self.bindBtn.mas_bottom).offset(15);
    }];
    [_mobileRightsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.mobileRightsView).offset(15);
        make.top.equalTo(self.mobileRightsView).offset(15);
    }];
    [_mobileRightsDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(60);
        make.left.equalTo(self.mobileRightsView).offset(15);
        make.top.equalTo(self.mobileRightsLabel.mas_bottom).offset(15);
    }];
    [_mobileProblemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(85);
        make.left.width.equalTo(self.view);
        make.top.equalTo(self.mobileRightsView.mas_bottom).offset(15);
    }];
    [_mobileProblemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.mobileProblemView).offset(15);
        make.top.equalTo(self.mobileProblemView).offset(15);
    }];
    [_mobileProblemDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.mobileProblemView).offset(15);
        make.top.equalTo(self.mobileProblemLabel.mas_bottom).offset(15);
    }];
}

@end
