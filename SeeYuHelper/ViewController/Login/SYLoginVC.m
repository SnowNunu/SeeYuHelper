//
//  SYLoginVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYLoginVC.h"
#import "SYAppDelegate.h"

@interface SYLoginVC ()

@property (nonatomic ,strong) UIImageView *logoImageView;

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *subTitleLabel;

@property (nonatomic ,strong) UILabel *welcomeLabel;

@property (nonatomic ,strong) UITextField *accountTextField;

@property (nonatomic ,strong) UIImageView *accountLineImageView;

@property (nonatomic ,strong) UITextField *passwordTextField;

@property (nonatomic ,strong) UIImageView *passwordLineImageView;

@property (nonatomic ,strong) UIButton *loginBtn;

@end

@implementation SYLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.accountTextField.text.length == 0 || [self.accountTextField.text stringByTrim].length == 0) {
            [MBProgressHUD sy_showError:@"请先输入账号"];
            return ;
        } else if (self.passwordTextField.text.length == 0 || [self.passwordTextField.text stringByTrim].length == 0) {
            [MBProgressHUD sy_showError:@"请先输入密码"];
            return;
        } else {
            NSString *url = [NSString stringWithFormat:@"%@?type=1&userId=%@&userPassword=%@",SY_WEB_SOCKET_URL,[self.accountTextField.text stringByTrim],[CocoaSecurity md5:[self.passwordTextField.text stringByTrim]].hexLower];
            [MBProgressHUD sy_showProgressHUD:@"登录中，请稍候"];
            [[SYAppDelegate sharedDelegate] startWebSocketService:url];
        }
    }];
    [SYNotificationCenter addObserver:self selector:@selector(dealLoginRequest:) name:@"login" object:nil];
}

#pragma mark - 设置子控件
- (void)_setupSubViews {
    UIImageView *logoImageView = [UIImageView new];
    logoImageView.image = SYImageNamed(@"logo");
    _logoImageView = logoImageView;
    [self.view addSubview:logoImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"SEEYU助手";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = SYColor(51, 51, 51);
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel = titleLabel;
    [self.view addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = @"连接你我距离更近";
    subTitleLabel.textAlignment = NSTextAlignmentLeft;
    subTitleLabel.textColor = SYColor(153, 153, 153);
    subTitleLabel.font = SYRegularFont(12);
    _subTitleLabel = subTitleLabel;
    [self.view addSubview:subTitleLabel];
    
    UILabel *welcomeLabel = [UILabel new];
    welcomeLabel.text = @"欢迎您";
    welcomeLabel.textAlignment = NSTextAlignmentLeft;
    welcomeLabel.textColor = SYColor(51, 51, 51);
    welcomeLabel.font = [UIFont boldSystemFontOfSize:30];
    _welcomeLabel = welcomeLabel;
    [self.view addSubview:welcomeLabel];
    
    UITextField *accountTextField = [UITextField new];
    accountTextField.placeholder = @"请输入账号";
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountTextField = accountTextField;
    [self.view addSubview:accountTextField];
    
    UIImageView *accountLineImageView = [UIImageView new];
    accountLineImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _accountLineImageView = accountLineImageView;
    [self.view addSubview:accountLineImageView];
    
    UITextField *passwordTextField = [UITextField new];
    passwordTextField.placeholder = @"请输入密码";
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.secureTextEntry = YES;
    _passwordTextField = passwordTextField;
    [self.view addSubview:passwordTextField];
    
    UIImageView *passwordLineImageView = [UIImageView new];
    passwordLineImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _passwordLineImageView = passwordLineImageView;
    [self.view addSubview:passwordLineImageView];
    
    UIButton *loginBtn = [UIButton new];
    loginBtn.backgroundColor = SYColor(159, 105, 235);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
}

- (void)_makeSubViewsConstraints {
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.view).offset(95);
        make.width.height.offset(45);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(15);
        make.height.equalTo(self.logoImageView).multipliedBy(0.5);
        make.top.equalTo(self.logoImageView);
    }];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.titleLabel);
        make.bottom.equalTo(self.logoImageView);
    }];
    [_welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(80);
        make.left.equalTo(self.logoImageView);
        make.height.offset(30);
    }];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.welcomeLabel.mas_bottom).offset(80);
        make.height.offset(30);
        make.left.equalTo(self.welcomeLabel);
        make.right.equalTo(self.view).offset(-30);
    }];
    [_accountLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.accountTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.accountTextField).offset(5);
    }];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountLineImageView.mas_bottom).offset(30);
        make.left.right.height.equalTo(self.accountTextField);
    }];
    [_passwordLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.passwordTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.passwordTextField).offset(5);
    }];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.accountTextField);
        make.height.offset(40);
        make.top.equalTo(self.passwordLineImageView.mas_bottom).offset(80);
    }];
}

// 解析登录请求
- (void)dealLoginRequest:(NSNotification *)notification {
    NSDictionary *dict = notification.object;
    if ([dict[@"code"] isEqualToString:@"200"]) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showTips:@"恭喜您登录成功！"];
        SYUser *user = [SYUser new];
        user.userId = self.accountTextField.text;
        user.userPassword = [CocoaSecurity md5:self.passwordTextField.text].hexLower;
        [self.viewModel.services.client saveUser:user];
        [self.viewModel.enterInfoSupplementViewCommand execute:nil];
    } else if ([dict[@"code"] isEqualToString:@"400"]) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showError:@"账号或密码有误，请检查!"];
    } else if ([dict[@"code"] isEqualToString:@"288"]) {
        SYUser *user = [SYUser new];
        user.userId = [self.accountTextField.text stringByTrim];
        user.userPassword = [CocoaSecurity md5:[self.passwordTextField.text stringByTrim]].hexLower;
        [self.viewModel.services.client saveUser:user];
        [self.viewModel.enterHomePageViewCommand execute:nil];
    }
}

- (void)dealloc {
    [SYNotificationCenter removeObserver:self];
}

@end
