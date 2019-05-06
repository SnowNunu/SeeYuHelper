//
//  SYUnionConfirmVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYUnionConfirmVC.h"

@interface SYUnionConfirmVC ()

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UILabel *withdrawalTipsLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic, strong) UILabel *moneyTitleLabel;

@property (nonatomic, strong) UILabel *moneyContentLabel;

@property (nonatomic, strong) UILabel *bankcardTitleLabel;

@property (nonatomic, strong) UILabel *bankcardContentLabel;

@property (nonatomic, strong) UILabel *realnameTitleLabel;

@property (nonatomic, strong) UILabel *realnameContentLabel;

@property (nonatomic, strong) UILabel *banknameTitleLabel;

@property (nonatomic, strong) UILabel *banknameContentLabel;

@property (nonatomic, strong) UILabel *contactTitleLabel;

@property (nonatomic, strong) UILabel *contactContentLabel;

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation SYUnionConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSDictionary *params = @{@"userId":self.viewModel.services.client.currentUserId,@"withdrawMoney":self.viewModel.confirmInfo[@"money"],@"type":@"2",@"withdrawName":self.viewModel.confirmInfo[@"realname"],@"withdrawAccountNum":self.viewModel.confirmInfo[@"bankcard"],@"withdrawContactInfo":self.viewModel.confirmInfo[@"contact"],@"withdrawBankName":self.viewModel.confirmInfo[@"bankname"]};
        [self.viewModel.withdrawalUnionCommand execute:params];
    }];
}

- (void)_setupSubViews {
    UIImageView *logoImageView = [UIImageView new];
    logoImageView.image = SYImageNamed(@"cardPay_large");
    _logoImageView = logoImageView;
    [self.view addSubview:logoImageView];
    
    UILabel *withdrawalTipsLabel = [UILabel new];
    withdrawalTipsLabel.textAlignment = NSTextAlignmentCenter;
    withdrawalTipsLabel.textColor = SYColor(51, 51, 51);
    withdrawalTipsLabel.font = SYRegularFont(17);
    withdrawalTipsLabel.text = @"提现到银行卡";
    _withdrawalTipsLabel = withdrawalTipsLabel;
    [self.view addSubview:withdrawalTipsLabel];
    
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.textColor = SYColor(51, 51, 51);
    moneyLabel.font = [UIFont boldSystemFontOfSize:30];
    moneyLabel.text = self.viewModel.confirmInfo[@"money"];
    _moneyLabel = moneyLabel;
    [self.view addSubview:moneyLabel];
    
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = SYColorFromHexString(@"#E0E0E0");
    _lineImageView = lineImageView;
    [self.view addSubview:lineImageView];
    
    UILabel *moneyTitleLabel = [UILabel new];
    moneyTitleLabel.textAlignment = NSTextAlignmentLeft;
    moneyTitleLabel.textColor = SYColor(153, 153, 153);
    moneyTitleLabel.font = SYRegularFont(15);
    moneyTitleLabel.text = @"提现金额";
    _moneyTitleLabel = moneyTitleLabel;
    [self.view addSubview:moneyTitleLabel];
    
    UILabel *moneyContentLabel = [UILabel new];
    moneyContentLabel.textAlignment = NSTextAlignmentLeft;
    moneyContentLabel.textColor = SYColor(51, 51, 51);
    moneyContentLabel.font = [UIFont boldSystemFontOfSize:16];
    moneyContentLabel.text = [NSString stringWithFormat:@"￥%@",self.viewModel.confirmInfo[@"money"]];
    _moneyContentLabel = moneyContentLabel;
    [self.view addSubview:moneyContentLabel];;
    
    UILabel *bankcardTitleLabel = [UILabel new];
    bankcardTitleLabel.textAlignment = NSTextAlignmentLeft;
    bankcardTitleLabel.textColor = SYColor(153, 153, 153);
    bankcardTitleLabel.font = SYRegularFont(15);
    bankcardTitleLabel.text = @"银行卡账号";
    _bankcardTitleLabel = bankcardTitleLabel;
    [self.view addSubview:bankcardTitleLabel];
    
    UILabel *bankcardContentLabel = [UILabel new];
    bankcardContentLabel.textAlignment = NSTextAlignmentLeft;
    bankcardContentLabel.textColor = SYColor(51, 51, 51);
    bankcardContentLabel.font = [UIFont boldSystemFontOfSize:16];
    bankcardContentLabel.text = self.viewModel.confirmInfo[@"bankcard"];
    _bankcardContentLabel = bankcardContentLabel;
    [self.view addSubview:bankcardContentLabel];
    
    UILabel *realnameTitleLabel = [UILabel new];
    realnameTitleLabel.textAlignment = NSTextAlignmentLeft;
    realnameTitleLabel.textColor = SYColor(153, 153, 153);
    realnameTitleLabel.font = SYRegularFont(15);
    realnameTitleLabel.text = @"银行卡实名";
    _realnameTitleLabel = realnameTitleLabel;
    [self.view addSubview:realnameTitleLabel];
    
    UILabel *realnameContentLabel = [UILabel new];
    realnameContentLabel.textAlignment = NSTextAlignmentLeft;
    realnameContentLabel.textColor = SYColor(51, 51, 51);
    realnameContentLabel.font = [UIFont boldSystemFontOfSize:16];
    realnameContentLabel.text = self.viewModel.confirmInfo[@"realname"];
    _realnameContentLabel = realnameContentLabel;
    [self.view addSubview:realnameContentLabel];
    
    UILabel *banknameTitleLabel = [UILabel new];
    banknameTitleLabel.textAlignment = NSTextAlignmentLeft;
    banknameTitleLabel.textColor = SYColor(153, 153, 153);
    banknameTitleLabel.font = SYRegularFont(15);
    banknameTitleLabel.text = @"银行名称";
    _banknameTitleLabel = banknameTitleLabel;
    [self.view addSubview:banknameTitleLabel];
    
    UILabel *banknameContentLabel = [UILabel new];
    banknameContentLabel.textAlignment = NSTextAlignmentLeft;
    banknameContentLabel.textColor = SYColor(51, 51, 51);
    banknameContentLabel.font = [UIFont boldSystemFontOfSize:16];
    banknameContentLabel.text = self.viewModel.confirmInfo[@"bankname"];
    _banknameContentLabel = banknameContentLabel;
    [self.view addSubview:banknameContentLabel];
    
    UILabel *contactTitleLabel = [UILabel new];
    contactTitleLabel.textAlignment = NSTextAlignmentLeft;
    contactTitleLabel.textColor = SYColor(153, 153, 153);
    contactTitleLabel.font = SYRegularFont(15);
    contactTitleLabel.text = @"联系方式";
    _contactTitleLabel = contactTitleLabel;
    [self.view addSubview:contactTitleLabel];
    
    UILabel *contactContentLabel = [UILabel new];
    contactContentLabel.textAlignment = NSTextAlignmentLeft;
    contactContentLabel.textColor = SYColor(51, 51, 51);
    contactContentLabel.font = [UIFont boldSystemFontOfSize:16];
    contactContentLabel.text = self.viewModel.confirmInfo[@"contact"];
    _contactContentLabel = contactContentLabel;
    [self.view addSubview:contactContentLabel];
    
    UIButton *confirmBtn = [UIButton new];
    [confirmBtn setTitle:@"确认提现" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = SYRegularFont(18);
    confirmBtn.backgroundColor = SYColor(159, 105, 235);
    _confirmBtn = confirmBtn;
    [self.view addSubview:confirmBtn];
}

- (void)_makeSubViewsConstraints {
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.centerX.equalTo(self.view);
        make.width.height.offset(60);
    }];
    [_withdrawalTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.height.offset(15);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawalTipsLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.height.offset(25);
    }];
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(45);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.offset(1);
    }];
    [_moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.lineImageView.mas_bottom).offset(30);
        make.height.offset(15);
        make.width.offset(75);
    }];
    [_moneyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyTitleLabel.mas_right).offset(30);
        make.height.top.equalTo(self.moneyTitleLabel);
    }];
    [_bankcardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.moneyTitleLabel.mas_bottom).offset(30);
        make.height.offset(15);
        make.width.offset(75);
    }];
    [_bankcardContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankcardTitleLabel.mas_right).offset(30);
        make.height.top.equalTo(self.bankcardTitleLabel);
    }];
    [_realnameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.bankcardTitleLabel.mas_bottom).offset(30);
        make.height.offset(15);
        make.width.offset(75);
    }];
    [_realnameContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.realnameTitleLabel.mas_right).offset(30);
        make.height.top.equalTo(self.realnameTitleLabel);
    }];
    [_banknameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.realnameTitleLabel.mas_bottom).offset(30);
        make.height.offset(15);
        make.width.offset(75);
    }];
    [_banknameContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.banknameTitleLabel.mas_right).offset(30);
        make.height.top.equalTo(self.banknameTitleLabel);
    }];
    [_contactTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.banknameTitleLabel.mas_bottom).offset(30);
        make.height.offset(15);
        make.width.offset(75);
    }];
    [_contactContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contactTitleLabel.mas_right).offset(30);
        make.height.top.equalTo(self.contactTitleLabel);
    }];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
}

@end
