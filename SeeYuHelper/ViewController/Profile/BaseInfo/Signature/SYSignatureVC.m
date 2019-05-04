//
//  SYSignatureVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSignatureVC.h"

@implementation SYSignatureVC

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
    [self.signatureView.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.signatureView.textView resignFirstResponder];
}

- (void)bindViewModel{
    [super bindViewModel];
    @weakify(self);
    RAC(self.viewModel, signature) = [RACSignal merge:@[RACObserve(self.signatureView.textView, text),self.signatureView.textView.rac_textSignal]];
    RAC(self.navigationItem.rightBarButtonItem , enabled) = self.viewModel.validCompleteSignal;
}
#pragma mark - 事件处理
- (void)_complete {
    /// 去掉全部为空格的情况
    if ([NSString sy_isEmpty:self.viewModel.signature]) {
        [MBProgressHUD sy_showTips:@"请输入正确的个性签名"];
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
- (void)_setupNavigationItem {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:nil titleColor:nil imageName:@"nav_btn_back" target:nil selector:nil textType:NO];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.cancelCommand;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:@"完成" titleColor:[UIColor whiteColor] imageName:nil target:self selector:@selector(_complete) textType:YES];
}

#pragma mark - 设置子控件
- (void)_setupSubViews {
    SYSignatureView *signatureView = [SYSignatureView signatureTextView];
    signatureView.sy_height = 81.0f;
    signatureView.sy_width = SY_SCREEN_WIDTH;
    signatureView.sy_y = SY_APPLICATION_TOP_BAR_HEIGHT + 16.0f;
    _signatureView = signatureView;
    [self.view addSubview:signatureView];
    self.signatureView.textView.text = self.viewModel.signature;
}


@end
