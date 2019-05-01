//
//  SYRegisterVC.m
//  Seeyu
//
//  Created by 唐荣才 on 2017/9/26.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYRegisterVC.h"

@interface SYRegisterVC ()


@end

@implementation SYRegisterVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /// 设置导航栏
    [self _setupNavigationItem];
    /// 设置子控件
    [self _setupSubViews];
}

- (void)_setupNavigationItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:@"登录" titleColor:nil imageName:nil target:nil selector:nil textType:YES];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.enterLoginViewCommand;
}

#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    [[self.registerView.completeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        /// 除去全是空格的情况
        if ([NSString sy_isEmpty:self.viewModel.alias]) {
            [MBProgressHUD sy_showTips:@"昵称不能为空"];
            return;
        }
        [self.viewModel.registerCommand execute:nil];
    }];
    [self.viewModel.registerCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        user.userPassword = self.viewModel.password;
        // 存储登录账号
        [SAMKeychain setRawLogin:user.userId];
        // 存储用户数据
        [self.viewModel.services.client loginUser:user];
        // 切换根控制器
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 发通知
            [MBProgressHUD sy_showProgressHUD:@"注册成功，登录中"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SYSwitchRootViewControllerNotification object:nil userInfo:@{SYSwitchRootViewControllerUserInfoKey:@(SYSwitchRootViewControllerFromTypeLogin)}];
        });
    }];
    [self.viewModel.registerCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    [self.registerView.chooseMaleTap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self _setMaleGender:YES];
    }];
    [self.registerView.chooseFemaleTap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self _setMaleGender:NO];
    }];
    // 选择年龄
    NSMutableArray *ageArray = [NSMutableArray new];
    for (int i = 0 ; i < 80; i++) {
        [ageArray addObject:[NSString stringWithFormat:@"%d",18 + i]];
    }
    [[self.registerView.ageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showPickerWithTitle:@"请选择年龄" andDataArrays:ageArray andSelectedValue:self.viewModel.age andType:@"age"];
    }];
    // 选择职业
    NSMutableArray *jobArray = [@[@"教师",@"工人",@"记者",@"演员",@"厨师",@"医生",@"护士",@"司机",@"军人",@"律师",@"商人",@"会计",@"店员",@"出纳",@"作家",@"导游",@"模特",@"警察",@"歌手",@"画家",@"裁缝",@"翻译",@"法官",@"保安",@"花匠",@"服务员",@"清洁工",@"建筑师",@"理发师",@"采购员",@"设计师",@"消防员",@"机修工",@"推销员",@"魔术师",@"模特儿",@"邮递员",@"售货员",@"救生员",@"运动员",@"工程师",@"飞行员",@"管理员",@"机械师",@"经纪人",@"审计员",@"漫画家",@"园艺师",@"科学家",@"主持人",@"程序员"] mutableCopy];
    [[self.registerView.jobBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self showPickerWithTitle:@"请选择职业" andDataArrays:jobArray andSelectedValue:self.viewModel.job andType:@"job"];
    }];
    // 选择收入
    NSMutableArray *incomeArray = [@[@"2000以下",@"2000-5000",@"5000-10000",@"10000-20000",@"20000以上"] mutableCopy];
    [[self.registerView.incomeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self showPickerWithTitle:@"请选择收入" andDataArrays:incomeArray andSelectedValue:self.viewModel.income andType:@"income"];
    }];
    // 选择身高
    NSMutableArray *heightArray = [NSMutableArray new];
    for (int i = 0 ; i <= 60; i++) {
        [heightArray addObject:[NSString stringWithFormat:@"%d",140 + i]];
    }
    [[self.registerView.heightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self showPickerWithTitle:@"请选择身高" andDataArrays:heightArray andSelectedValue:self.viewModel.height andType:@"height"];
    }];
    // 选择婚姻状态
    NSMutableArray *marryArray = [@[@"未婚",@"已婚",@"离异",@"保密"] mutableCopy];
    [[self.registerView.maritalStatusBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self showPickerWithTitle:@"请选择婚姻状态" andDataArrays:marryArray andSelectedValue:self.viewModel.maritalStatus andType:@"marry"];
    }];
    RAC(self.viewModel,alias) = [RACSignal merge:@[RACObserve(self.registerView.aliasTextField, text),self.registerView.aliasTextField.rac_textSignal]];
    [RACObserve(self.viewModel, age) subscribeNext:^(NSString *age) {
        @strongify(self);
        [self.registerView.ageBtn setTitle:age forState:UIControlStateNormal];
    }];
    [RACObserve(self.viewModel, job) subscribeNext:^(NSString *job) {
        @strongify(self);
        [self.registerView.jobBtn setTitle:job forState:UIControlStateNormal];
    }];
    [RACObserve(self.viewModel, income) subscribeNext:^(NSString *income) {
        @strongify(self);
        [self.registerView.incomeBtn setTitle:income forState:UIControlStateNormal];
    }];
    [RACObserve(self.viewModel, height) subscribeNext:^(NSString *height) {
        @strongify(self);
        [self.registerView.heightBtn setTitle:height forState:UIControlStateNormal];
    }];
    [RACObserve(self.viewModel, maritalStatus) subscribeNext:^(NSString *marry) {
        @strongify(self);
        [self.registerView.maritalStatusBtn setTitle:marry forState:UIControlStateNormal];
    }];
}

#pragma mark - 设置子控件
- (void)_setupSubViews {
    SYRegisterView *view = [SYRegisterView registerView];
    _registerView = view;
    [self.view addSubview:_registerView];
    [_registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.viewModel.age = @"25";
    self.viewModel.gender = @"男";
    self.viewModel.job = @"工人";
    self.viewModel.income = @"2000以下";
    self.viewModel.height = @"172";
    self.viewModel.maritalStatus = @"未婚";
}

#pragma mark - 设置性别
- (void)_setMaleGender:(BOOL) gender {
    _registerView.maleBtn.selected = gender;
    _registerView.femaleBtn.selected = !gender;
    _registerView.maleLabel.textColor = gender ? SYColor(196, 145, 253) : SYColor(153, 153, 153);
    _registerView.femaleLabel.textColor = !gender ? SYColor(196, 145, 253) : SYColor(153, 153, 153);
    self.viewModel.gender = _registerView.maleBtn.selected ? @"男" : @"女";
}

// 显示滑动选择页
- (void)showPickerWithTitle:(NSString*)title andDataArrays: (NSMutableArray*)array andSelectedValue: (NSString*) value andType: (NSString*) type {
    NSInteger row = [array indexOfObject:value];
    @weakify(self)
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:array initialSelection:row doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        @strongify(self)
        if ([type isEqualToString:@"age"]) {
            self.viewModel.age = array[selectedIndex];
        } else if ([type isEqualToString:@"job"]) {
            self.viewModel.job = array[selectedIndex];
        } else if ([type isEqualToString:@"income"]) {
            self.viewModel.income = array[selectedIndex];
        } else if ([type isEqualToString:@"height"]) {
            self.viewModel.height = array[selectedIndex];
        } else if ([type isEqualToString:@"marry"]) {
            self.viewModel.maritalStatus = array[selectedIndex];
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"取消了选择");
    } origin:self.view];
    [picker showActionSheetPicker];
}

@end
