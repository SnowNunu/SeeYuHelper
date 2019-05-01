//
//  SYSigninVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSigninVC.h"
#import "SYSigninInfoModel.h"
#import "SYSigninModel.h"

@interface SYSigninVC ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *signinDaysLabel;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *signinBtn;

@end

@implementation SYSigninVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestSigninInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, infoModel) subscribeNext:^(SYSigninInfoModel *infoModel) {
        if (infoModel != nil) {
            if (infoModel.recentTime != nil && [infoModel.recentTime sy_isToday]) {
                // 今天已经签到过了
                self.signinBtn.userInteractionEnabled = NO;
                self.signinBtn.backgroundColor = [UIColor grayColor];
            } else {
                self.signinBtn.userInteractionEnabled = YES;
            }
            self.signinDaysLabel.text = [NSString stringWithFormat:@"已连续签到%d天",infoModel.count];
            for (int i = 0; i < infoModel.awards.count; i++) {
                NSDictionary *dict = infoModel.awards[i];
                SYSigninModel *model = [SYSigninModel yy_modelWithDictionary:dict];
                if (i < infoModel.count) {
                    UIImageView *bgImageView = [self.view viewWithTag:688 + i];
                    bgImageView.image = SYImageNamed(@"icon_checked");
                    UILabel *dayLabel = [self.view viewWithTag:788 + i];
                    dayLabel.textColor = [UIColor whiteColor];
                    UIImageView *iconImageView = [self.view viewWithTag:888 + i];
                    iconImageView.hidden = YES;
                } else {
                    UIImageView *bgImageView = [self.view viewWithTag:688 + i];
                    bgImageView.image = nil;
                    UILabel *dayLabel = [self.view viewWithTag:788 + i];
                    dayLabel.textColor = SYColor(159, 105, 235);
                    UIImageView *iconImageView = [self.view viewWithTag:888 + i];
                    iconImageView.hidden = NO;
                }
            }
        }
    }];
    [[self.signinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.userSigninCommand execute:nil];
    }];
    [self.viewModel.userSigninCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYSigninInfoModel *model) {
        SYSigninInfoModel *tempModel = self.viewModel.infoModel;
        tempModel.count = model.day;
        tempModel.recentTime = [NSDate new];
        self.viewModel.infoModel = tempModel;
        [MBProgressHUD sy_showTips:@"签到成功" addedToView:self.view];
    }];
    [self.viewModel.userSigninCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

- (void)_setupSubViews {
    self.view.backgroundColor = SYColorAlpha(0, 0, 0, 0.2);
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SYSharedAppDelegate dismissVC:self];
        });
    }];
    [self.view addGestureRecognizer:tap];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 15.f;
    _bgView = bgView;
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tapNone = [UITapGestureRecognizer new];
    [[tapNone rac_gestureSignal] subscribeNext:^(id x) {
        // 防止点击触发移除界面的响应
    }];
    [bgView addGestureRecognizer:tapNone];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = SYColor(159, 105, 235);
    titleLabel.textColor = SYColor(255, 255, 255);
    titleLabel.font = SYRegularFont(18);
    titleLabel.text = @"每日签到送钻石";
    _titleLabel = titleLabel;
    [bgView addSubview:titleLabel];
    
    UILabel *signinDaysLabel = [UILabel new];
    signinDaysLabel.textAlignment = NSTextAlignmentCenter;
    signinDaysLabel.textColor = SYColor(0, 0, 0);
    signinDaysLabel.font = SYRegularFont(18);
    signinDaysLabel.text = @"已连续签到1天";
    _signinDaysLabel = signinDaysLabel;
    [bgView addSubview:signinDaysLabel];
    
    CGFloat margin = (SY_SCREEN_WIDTH - 60 - 30 * 7) / 6;
    for (int i = 0; i < 7; i++) {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.layer.cornerRadius = 5;
        bgImageView.layer.borderWidth = 1.f;
        bgImageView.layer.borderColor = SYColor(159, 105, 235).CGColor;
        bgImageView.layer.masksToBounds = YES;
        bgImageView.tag = 688 + i;
        [bgView addSubview:bgImageView];
        
        UILabel *dayLabel = [UILabel new];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.text = [NSString stringWithFormat:@"%d天",i + 1];
        dayLabel.font = SYRegularFont(12);
        dayLabel.textColor = SYColor(153, 105, 235);
        dayLabel.tag = 788 + i;
        [bgImageView addSubview:dayLabel];
        
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.tag = 888 + i;
        iconImageView.image = SYImageNamed(@"icon_diamond");
        [bgImageView addSubview:iconImageView];
        
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(30);
            make.height.offset(40);
            make.top.equalTo(signinDaysLabel.mas_bottom).offset(15);
            make.left.equalTo(self.bgView).offset(15 + i *(margin + 30));
        }];
        [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgImageView);
            make.top.equalTo(bgImageView).offset(6);
            make.height.offset(14);
        }];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(dayLabel);
            make.bottom.equalTo(bgImageView).offset(-6);
            make.width.height.offset(14);
        }];
    }
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.textColor = SYColor(153, 153, 153);
    tipsLabel.font = SYRegularFont(14);
    tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipsLabel.numberOfLines = 0;
    tipsLabel.text = @"1.第一天1钻石，之后每天递增1钻石。\n2.7日及7日后，每日签到可得7钻石。\n3.断签后签到奖励重置为1，重新累计。";
    _tipsLabel = tipsLabel;
    [bgView addSubview:tipsLabel];
    
    UIButton *signinBtn = [UIButton new];
    signinBtn.backgroundColor = SYColor(159, 105, 235);
    [signinBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signinBtn setTitleColor:SYColor(255, 255, 255) forState:UIControlStateNormal];
    signinBtn.titleLabel.font = SYRegularFont(18);
    signinBtn.layer.cornerRadius = 10.f;
    signinBtn.layer.masksToBounds = YES;
    signinBtn.userInteractionEnabled = NO;
    _signinBtn = signinBtn;
    [bgView addSubview:signinBtn];
}

- (void)_makeSubViewsConstraints {
    CGFloat height = (SY_SCREEN_WIDTH - 30) * 0.82;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view).offset(-30);
        make.height.offset(height);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.equalTo(self.bgView);
        make.height.equalTo(self.bgView).multipliedBy(0.14);
    }];
    [_signinDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.bgView);
        make.height.offset(20);
    }];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signinDaysLabel.mas_bottom).offset(70);
        make.left.equalTo(self.bgView).offset(15);
        make.height.offset(68);
    }];
    [_signinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView).offset(-15);
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.height.equalTo(self.bgView).multipliedBy(0.14);
    }];
}

@end
