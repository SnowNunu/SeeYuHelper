//
//  SYPasswordModifyVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPasswordModifyVC.h"

@interface SYPasswordModifyVC ()

@property (nonatomic ,strong) UITextField *oldPasswordTextField;

@property (nonatomic ,strong) UIImageView *line1ImageView;

@property (nonatomic ,strong) UITextField *freshPasswordTextField;

@property (nonatomic ,strong) UIImageView *line2ImageView;

@property (nonatomic ,strong) UITextField *repeatPasswordTextField;

@property (nonatomic ,strong) UIImageView *line3ImageView;

@property (nonatomic ,strong) UIButton *submitBtn;

@end

@implementation SYPasswordModifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([self.oldPasswordTextField.text stringByTrim].length == 0) {
            [MBProgressHUD sy_showTips:@"请先输入原密码!"];
        } else if ([self.freshPasswordTextField.text stringByTrim].length == 0) {
            [MBProgressHUD sy_showTips:@"请先输入新密码!"];
        } else if ([self.repeatPasswordTextField.text stringByTrim].length == 0) {
            [MBProgressHUD sy_showTips:@"请先输入重复密码!"];
        } else if (![[self.repeatPasswordTextField.text stringByTrim] isEqualToString:[self.freshPasswordTextField.text stringByTrim]]) {
            [MBProgressHUD sy_showTips:@"两次密码输入不一致，请确认!"];
        } else {
            NSDictionary *params = @{@"userId":self.viewModel.services.client.currentUserId,@"oldPassword":[CocoaSecurity md5:[self.oldPasswordTextField.text stringByTrim]].hexLower,@"newPassword":[CocoaSecurity md5:[self.freshPasswordTextField.text stringByTrim]].hexLower};
            [self.viewModel.updatePasswordCommand execute:params];
        }
    }];
}

- (void)_setupSubViews {
    UITextField *oldPasswordTextField = [UITextField new];
    oldPasswordTextField.placeholder = @"请输入原密码";
    oldPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    oldPasswordTextField.secureTextEntry = YES;
    _oldPasswordTextField = oldPasswordTextField;
    [self.view addSubview:oldPasswordTextField];
    
    UIImageView *line1ImageView = [UIImageView new];
    line1ImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _line1ImageView = line1ImageView;
    [self.view addSubview:line1ImageView];
    
    UITextField *freshPasswordTextField = [UITextField new];
    freshPasswordTextField.placeholder = @"请输入新密码";
    freshPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    freshPasswordTextField.secureTextEntry = YES;
    _freshPasswordTextField = freshPasswordTextField;
    [self.view addSubview:freshPasswordTextField];
    
    UIImageView *line2ImageView = [UIImageView new];
    line2ImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _line2ImageView = line2ImageView;
    [self.view addSubview:line2ImageView];
    
    UITextField *repeatPasswordTextField = [UITextField new];
    repeatPasswordTextField.placeholder = @"请再次输入新密码";
    repeatPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    repeatPasswordTextField.secureTextEntry = YES;
    _repeatPasswordTextField = repeatPasswordTextField;
    [self.view addSubview:repeatPasswordTextField];
    
    UIImageView *line3ImageView = [UIImageView new];
    line3ImageView.backgroundColor = SYColorFromHexString(@"#A7A7A7");
    _line3ImageView = line3ImageView;
    [self.view addSubview:line3ImageView];
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.backgroundColor = SYColor(159, 105, 235);
    [submitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    _submitBtn = submitBtn;
    [self.view addSubview:submitBtn];
}

- (void)_makeSubViewsConstraints {
    [_oldPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.offset(30);
    }];
    [_line1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.oldPasswordTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.oldPasswordTextField).offset(5);
    }];
    [_freshPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.oldPasswordTextField);
        make.top.equalTo(self.oldPasswordTextField.mas_bottom).offset(30);
    }];
    [_line2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.freshPasswordTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.freshPasswordTextField).offset(5);
    }];
    [_repeatPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.oldPasswordTextField);
        make.top.equalTo(self.freshPasswordTextField.mas_bottom).offset(30);
    }];
    [_line3ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.repeatPasswordTextField);
        make.height.offset(1);
        make.bottom.equalTo(self.repeatPasswordTextField).offset(5);
    }];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.repeatPasswordTextField);
        make.top.equalTo(self.repeatPasswordTextField.mas_bottom).offset(60);
        make.height.offset(40);
    }];
}

@end
