//
//  SYNicknameModifyVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYNicknameModifyVC.h"

@interface SYNicknameModifyVC ()

@end

@implementation SYNicknameModifyVC

- (void)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupNavigationItem];
    [self _setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}

- (void)bindViewModel{
    [super bindViewModel];
    RAC(self.viewModel, text) = [RACSignal merge:@[RACObserve(self.textField, text),self.textField.rac_textSignal]];
    RAC(self.navigationItem.rightBarButtonItem, enabled) = self.viewModel.validCompleteSignal;
}

- (void)_complete {
    /// 除去全是空格的情况
    if ([NSString sy_isEmpty:self.viewModel.text]) {
        [MBProgressHUD sy_showTips:@"请输入正确的昵称"];
        return;
    }
    [self.viewModel.completeCommand execute:nil];
}

#pragma mark - 初始化
- (void)_setup {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    /// 适配 iOS 11
    SYAdjustsScrollViewInsets_Never(scrollView);
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:nil titleColor:nil imageName:@"nav_btn_back" target:nil selector:nil textType:NO];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.cancelCommand;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:@"完成" titleColor:[UIColor whiteColor] imageName:nil target:self selector:@selector(_complete) textType:YES];
}

#pragma mark - 设置子控件
- (void)_setupSubViews {
    UITextField *textField = [UITextField new];
    textField.font = SYRegularFont(17);
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.borderWidth = 1.f;
    textField.layer.borderColor = SY_MAIN_LINE_COLOR_1.CGColor;
    [textField sy_limitMaxLength:8];
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField = textField;
    [self.view addSubview:textField];
    textField.text = self.viewModel.text;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SY_APPLICATION_TOP_BAR_HEIGHT + 16.f);
        make.left.width.equalTo(self.view);
        make.height.offset(50);
    }];
}


@end
