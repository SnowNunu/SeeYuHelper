//
//  SYGiftPackageVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGiftPackageVC.h"
#import "SYGiftPackageModel.h"

@interface SYGiftPackageVC ()

@property (nonatomic, strong) NSArray *dayArray;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *signinBtn;

@property (nonatomic, strong) UILabel *tipsTitleLabel;

@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation SYGiftPackageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dayArray = @[@"第一天",@"第二天",@"第三天",@"第四天",@"第五天",@"第六天",@"第七天",];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [[self.signinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.receiveGiftCommand execute:nil];
    }];
    [self.viewModel.receiveGiftCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYGiftPackageModel *model) {
        [MBProgressHUD sy_showTips:@"领取成功" addedToView:self.view];
        UIImageView *imageView = [self.view viewWithTag:888 + model.day - 1];
        imageView.hidden = NO;
        self.signinBtn.backgroundColor = [UIColor grayColor];
        self.signinBtn.userInteractionEnabled = NO;
    }];
    [self.viewModel.receiveGiftCommand.errors subscribeNext:^(NSError *error) {
        if (error.code == 107) {
            [MBProgressHUD sy_showTips:@"您已经领取过，当天不能重复领取！" addedToView:self.view];
        } else {
            [MBProgressHUD sy_showErrorTips:error addedToView:self.view];
        }
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
    titleLabel.textColor = SYColor(255, 255, 255);
    titleLabel.backgroundColor = SYColor(159, 105, 235);
    titleLabel.font = SYRegularFont(21);
    titleLabel.text = @"新人签到礼包";
    _titleLabel = titleLabel;
    [bgView addSubview:titleLabel];
    
    CGFloat width = (SY_SCREEN_WIDTH - 30);
    CGFloat height = width * 1.16;
    CGFloat margin = width * 0.2 / 5;
    CGFloat margin1 = (width - width * 0.6 - margin * 2) / 2;
    for (int i = 0 ; i < 7; i++) {
        UIView *cellBgView = [UIView new];
        cellBgView.layer.cornerRadius = 5.f;
        cellBgView.layer.borderColor = SYColor(159, 105, 235).CGColor;
        cellBgView.layer.borderWidth = 1.f;
        cellBgView.clipsToBounds = NO;
        [bgView addSubview:cellBgView];
        
        SYGiftPackageModel *model = self.viewModel.giftPackagesArray[i];
        UIImageView *iconImageView = [UIImageView new];
        if (model.giftRecordType == 1) {
            // 钻石
            iconImageView.image = SYImageNamed(@"icon_check_diamond");
        } else if (model.giftRecordType == 2) {
            // VIP
            iconImageView.image = SYImageNamed(@"icon_check_vip");
        } else {
            // 礼物类型
            [iconImageView yy_setImageWithURL:[NSURL URLWithString:model.giftRecordGiftUrl] placeholder:SYImageNamed(@"icon_check_gift") options:SYWebImageOptionAutomatic completion:NULL];
        }
        [cellBgView addSubview:iconImageView];
        
        UILabel *dayLabel = [UILabel new];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.textColor = SYColor(159, 105, 235);
        dayLabel.font = SYRegularFont(13);
        dayLabel.text = _dayArray[i];
        [cellBgView addSubview:dayLabel];
        
        UILabel *numberLabel = [UILabel new];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = SYColor(159, 105, 235);
        numberLabel.font = SYRegularFont(13);
        if (model.giftRecordType == 1) {
            numberLabel.text = [NSString stringWithFormat:@"%d钻石",model.giftRecordNum];
        } else if (model.giftRecordType == 2) {
            numberLabel.text = [NSString stringWithFormat:@"%d天会员",model.giftRecordNum];
        } else {
            numberLabel.text = [NSString stringWithFormat:@"%d * %@",model.giftRecordNum,model.giftRecordGiftName];
        }
        [cellBgView addSubview:numberLabel];
        
        UIImageView *signinStateImageView = [UIImageView new];
        signinStateImageView.image = SYImageNamed(@"icon_check_lips");
        signinStateImageView.tag = 888 + i;
        [cellBgView addSubview:signinStateImageView];
        signinStateImageView.hidden = model.giftRecordIsReceive == 0 ? YES : NO;
        
        if (i < 4) {
            [cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).offset(height * 0.075);
                make.width.offset(width * 0.2);
                make.left.equalTo(self.bgView).offset(margin + i * (width * 0.2 + margin));
                make.height.offset(width * 0.2 * 0.814);
            }];
        } else {
            [cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(width * 0.2);
                make.height.offset(width * 0.2 * 0.814);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(height * 0.25);
                if (i == 4) {
                    make.left.equalTo(self.bgView).offset(margin1);
                } else if (i == 5) {
                    make.centerX.equalTo(self.bgView);
                } else {
                    make.right.equalTo(self.bgView).offset(-margin1);
                }
            }];
        }
        [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(iconImageView);
            make.bottom.equalTo(iconImageView.mas_top);
            make.height.offset(15);
        }];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cellBgView);
            make.width.height.offset(width * 0.2 * 0.25);
        }];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(iconImageView);
            make.top.equalTo(iconImageView.mas_bottom);
            make.height.offset(15);
        }];
        [signinStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(30);
            make.right.equalTo(cellBgView).offset(margin * 0.5);
            make.bottom.equalTo(cellBgView).offset(margin * 0.5);
        }];
    }
    
    UIButton *signinBtn = [UIButton new];
    signinBtn.backgroundColor = SYColor(159, 105, 235);
    [signinBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signinBtn setTitleColor:SYColor(255, 255, 255) forState:UIControlStateNormal];
    signinBtn.titleLabel.font = SYRegularFont(21);
    signinBtn.layer.cornerRadius = 10.f;
    signinBtn.layer.masksToBounds = YES;
    _signinBtn = signinBtn;
    [bgView addSubview:signinBtn];
    
    UILabel *tipsTitleLabel = [UILabel new];
    tipsTitleLabel.text = @"活动规则";
    tipsTitleLabel.textAlignment = NSTextAlignmentCenter;
    tipsTitleLabel.textColor = SYColor(153, 153, 153);
    tipsTitleLabel.font = SYRegularFont(15);
    _tipsTitleLabel = tipsTitleLabel;
    [bgView addSubview:tipsTitleLabel];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.textColor = SYColor(153, 153, 153);
    tipsLabel.font = SYRegularFont(14);
    tipsLabel.text = @"1.登录用户每天可签到1次，并领取奖励。礼物按日发放，过期无法领取。\n2.钻石可用于与主播连线。";
    tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipsLabel.numberOfLines = 0;
    _tipsLabel = tipsLabel;
    [bgView addSubview:tipsLabel];
}

- (void)_makeSubViewsConstraints {
    CGFloat height = (SY_SCREEN_WIDTH - 30) * 1.16;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view).offset(-30);
        make.height.offset(height);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.equalTo(self.bgView).multipliedBy(0.1);
    }];
    [_signinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.bgView).offset(height * 0.57);
        make.height.offset(0.1 * height);
    }];
    [_tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.height.offset(15);
        make.top.equalTo(self.signinBtn.mas_bottom).offset(height * 0.075);
    }];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-5);
        make.top.equalTo(self.tipsTitleLabel.mas_bottom).offset(10);
    }];
}

@end
