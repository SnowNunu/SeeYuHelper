//
//  SYGuideVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGuideVC.h"

@interface SYGuideVC ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation SYGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.loginCommand execute:nil];
    }];
    [[_registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.registerCommand execute:nil];
    }];
}

- (void)_setupSubViews {
    UIImageView *backgroundImageView = [UIImageView new];
    backgroundImageView.image = SYImageNamed(@"launchImage");
    _backgroundImageView = backgroundImageView;
    [self.view addSubview:backgroundImageView];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitleColor:SYColor(159, 105, 235) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = SYRegularFont(18);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 20.f;
    _loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [[UIButton alloc]init];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.backgroundColor = SYColor(159, 105, 235);
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = SYRegularFont(18);
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 20.f;
    _registerBtn = registerBtn;
    [self.view addSubview:registerBtn];
}

- (void)_makeSubViewsConstraints {
    CGFloat margin = (SY_SCREEN_WIDTH - 30 - 2 * 100 ) / 2;
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(40);
        make.left.equalTo(self.view).offset(margin);
        make.bottom.equalTo(self.view).offset(-60);
    }];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.equalTo(self.loginBtn);
        make.left.equalTo(self.loginBtn.mas_right).offset(30);
    }];
}

@end
