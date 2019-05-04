//
//  SYAboutVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAboutVC.h"

@interface SYAboutVC ()

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UILabel *appNameLabel;

@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) UIButton *checkUpdateBtn;

@end

@implementation SYAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}


- (void)_setupSubViews {
    UIImageView *logoImageView = [UIImageView new];
    logoImageView.image = SYImageNamed(@"logo");
    _logoImageView = logoImageView;
    [self.view addSubview:logoImageView];
    
    UILabel *appNameLabel = [UILabel new];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.text = @"SEEYU助手";
    appNameLabel.font = [UIFont boldSystemFontOfSize:20.f];
    appNameLabel.textColor = SYColor(51, 51, 51);
    _appNameLabel = appNameLabel;
    [self.view addSubview:appNameLabel];
    
    UILabel *versionLabel = [UILabel new];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = [NSString stringWithFormat:@"V%@",SY_APP_BUILD];
    versionLabel.font = SYRegularFont(18);
    versionLabel.textColor = SYColor(153, 153, 153);
    _versionLabel = versionLabel;
    [self.view addSubview:versionLabel];
    
    UIButton *checkUpdateBtn = [UIButton new];
    checkUpdateBtn.backgroundColor = SYColor(159, 105, 235);
    [checkUpdateBtn setTitle:@"检查更新" forState:UIControlStateNormal];
    [checkUpdateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkUpdateBtn.titleLabel.font = SYRegularFont(18);
    _checkUpdateBtn = checkUpdateBtn;
    [self.view addSubview:checkUpdateBtn];
}

- (void)_makeSubViewsConstraints {
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.centerX.equalTo(self.view);
        make.width.height.offset(100);
    }];
    [_appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.height.offset(20);
    }];
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.appNameLabel.mas_bottom).offset(9);
        make.height.offset(15);
    }];
    [_checkUpdateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.offset(50);
    }];
}

@end
