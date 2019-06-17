//
//  SYUserDetailVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYUserDetailVC.h"

@interface SYUserDetailVC ()

@property (nonatomic, strong) UIImageView *avatarImageview;

@property (nonatomic, strong) UILabel *aliasLabel;

@property (nonatomic, strong) UILabel *signatureLabel;

@property (nonatomic, strong) UILabel *infoTipsLabel;

// 昵称文本
@property (nonatomic, strong) UILabel *aliasInfoLabel;

// 性别文本
@property (nonatomic, strong) UILabel *genderInfoLabel;

// 年龄文本
@property (nonatomic, strong) UILabel *ageInfoLabel;

// 城市文本
@property (nonatomic, strong) UILabel *cityInfoLabel;

// 身高文本
@property (nonatomic, strong) UILabel *heightInfoLabel;

// 收入文本
@property (nonatomic, strong) UILabel *incomeInfoLabel;

// 职业文本
@property (nonatomic, strong) UILabel *jobInfoLabel;

// 爱好文本
@property (nonatomic, strong) UILabel *hobbyInfoLabel;

// 生日文本
@property (nonatomic, strong) UILabel *birthdayInfoLabel;

// 星座文本
@property (nonatomic, strong) UILabel *constellationInfoLabel;

// 婚姻文本
@property (nonatomic, strong) UILabel *marryInfoLabel;

// 钻石文本
@property (nonatomic, strong) UILabel *diamondsInfoLabel;

// 充值文本
@property (nonatomic, strong) UILabel *rechargeInfoLabel;

// VIP文本
@property (nonatomic, strong) UILabel *vipStatusInfoLabel;

// 发起视频按钮
@property (nonatomic, strong) UIButton *videoBtn;

@end

@implementation SYUserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestUserDetailInfoCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _marryInfoLabel.hidden = YES;
    _diamondsInfoLabel.hidden = YES;
    _rechargeInfoLabel.hidden = YES;
    _vipStatusInfoLabel.hidden = YES;
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        @strongify(self)
        if (user != nil) {
            if (user.userHeadImg != nil && user.userHeadImg.length > 0) {
                [self.avatarImageview yy_setImageWithURL:[NSURL URLWithString:user.userHeadImg] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
            }
            if (user.userName != nil && user.userName.length > 0) {
                self.aliasLabel.text = user.userName;
            }
            if (user.userSignature != nil && user.userSignature.length > 0) {
                self.signatureLabel.text = user.userSignature;
            }
            // 昵称
            NSMutableAttributedString *aliasString;
            if (![user.userName sy_isNullOrNil] && user.userName.length > 0) {
                aliasString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"昵称：%@",user.userName]];
                [aliasString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, aliasString.length - 3)];
            } else {
                aliasString = [[NSMutableAttributedString alloc] initWithString:@"昵称：未填写"];
                [aliasString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, aliasString.length - 3)];
            }
            self.aliasInfoLabel.attributedText = aliasString;
            // 性别
            NSMutableAttributedString *genderString;
            if (![user.userGender sy_isNullOrNil] && user.userGender.length > 0) {
                genderString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"性别：%@",user.userGender]];
                [genderString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, genderString.length - 3)];
            } else {
                genderString = [[NSMutableAttributedString alloc] initWithString:@"性别：未填写"];
                [genderString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, genderString.length - 3)];
            }
            self.genderInfoLabel.attributedText = genderString;
            // 年龄
            NSMutableAttributedString *ageString;
            if (![user.userAge sy_isNullOrNil] && user.userAge.length > 0) {
                ageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"年龄：%@",user.userAge]];
                [ageString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, ageString.length - 3)];
            } else {
                ageString = [[NSMutableAttributedString alloc] initWithString:@"年龄：未填写"];
                [ageString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, ageString.length - 3)];
            }
            self.ageInfoLabel.attributedText = ageString;
            // 城市
            NSMutableAttributedString *cityString;
            if (![user.userAddress sy_isNullOrNil] && user.userAddress.length > 0) {
                cityString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"城市：%@",user.userAddress]];
                [cityString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, cityString.length - 3)];
            } else {
                cityString = [[NSMutableAttributedString alloc] initWithString:@"城市：未填写"];
                [cityString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, cityString.length - 3)];
            }
            self.cityInfoLabel.attributedText = cityString;
            // 身高
            NSMutableAttributedString *heightString;
            if (![user.userHeight sy_isNullOrNil] && user.userHeight.length > 0) {
                heightString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"身高：%@",user.userHeight]];
                [heightString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, heightString.length - 3)];
            } else {
                heightString = [[NSMutableAttributedString alloc] initWithString:@"身高：未填写"];
                [heightString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, heightString.length - 3)];
            }
            self.heightInfoLabel.attributedText = heightString;
            // 收入
            NSMutableAttributedString *incomeString;
            if (![user.userIncome sy_isNullOrNil] && user.userIncome.length > 0) {
                incomeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收入：%@",user.userIncome]];
                [incomeString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, incomeString.length - 3)];
            } else {
                incomeString = [[NSMutableAttributedString alloc] initWithString:@"收入：未填写"];
                [incomeString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, incomeString.length - 3)];
            }
            self.incomeInfoLabel.attributedText = incomeString;
            // 职业
            NSMutableAttributedString *jobString;
            if (![user.userProfession sy_isNullOrNil] && user.userProfession.length > 0) {
                jobString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"职业：%@",user.userProfession]];
                [jobString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, jobString.length - 3)];
            } else {
                jobString = [[NSMutableAttributedString alloc] initWithString:@"职业：未填写"];
                [jobString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, jobString.length - 3)];
            }
            self.jobInfoLabel.attributedText = jobString;
            // 爱好
            NSMutableAttributedString *hobbyString;
            if (![user.userSpecialty sy_isNullOrNil] && user.userSpecialty.length > 0) {
                hobbyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"爱好：%@",user.userSpecialty]];
                [hobbyString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, hobbyString.length - 3)];
            } else {
                hobbyString = [[NSMutableAttributedString alloc] initWithString:@"爱好：未填写"];
                [hobbyString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, hobbyString.length - 3)];
            }
            self.hobbyInfoLabel.attributedText = hobbyString;
            // 生日
            NSMutableAttributedString *birthdayString;
            if (![user.userBirthday sy_isNullOrNil] && user.userBirthday.length > 0) {
                birthdayString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"生日：%@",user.userBirthday]];
                [birthdayString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, birthdayString.length - 3)];
            } else {
                birthdayString = [[NSMutableAttributedString alloc] initWithString:@"生日：未填写"];
                [birthdayString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, birthdayString.length - 3)];
            }
            self.birthdayInfoLabel.attributedText = birthdayString;
            // 星座
            NSMutableAttributedString *constellationString;
            if (![user.userConstellation sy_isNullOrNil] && user.userConstellation.length > 0) {
                constellationString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"星座：%@",user.userConstellation]];
                [constellationString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, constellationString.length - 3)];
            } else {
                constellationString = [[NSMutableAttributedString alloc] initWithString:@"星座：未填写"];
                [constellationString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, constellationString.length - 3)];
            }
            self.constellationInfoLabel.attributedText = constellationString;
            // 婚姻
            NSMutableAttributedString *marryString;
            if (![user.userMarry sy_isNullOrNil] && user.userMarry.length > 0) {
                marryString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"婚姻：%@",user.userMarry]];
                [marryString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, marryString.length - 3)];
            } else {
                marryString = [[NSMutableAttributedString alloc] initWithString:@"婚姻：未填写"];
                [marryString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, marryString.length - 3)];
            }
            self.marryInfoLabel.attributedText = marryString;
            // 钻石
            NSMutableAttributedString *diamondsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"钻石：%d",user.userDiamond]];
            [diamondsString addAttribute:NSForegroundColorAttributeName value:SYColor(159, 105, 235) range:NSMakeRange(3, diamondsString.length - 3)];
            self.diamondsInfoLabel.attributedText = diamondsString;
            // 充值
            NSMutableAttributedString *rechargeString;
            rechargeString = [[NSMutableAttributedString alloc] initWithString:@"充值：500元"];
            [rechargeString addAttribute:NSForegroundColorAttributeName value:SYColor(159, 105, 235) range:NSMakeRange(3, rechargeString.length - 3)];
            self.rechargeInfoLabel.attributedText = rechargeString;
            // VIP
            NSMutableAttributedString *vipString;
            if (user.userVipStatus == 0) {
                vipString = [[NSMutableAttributedString alloc] initWithString:@"VIP：否"];
            } else {
                vipString = [[NSMutableAttributedString alloc] initWithString:@"VIP：是"];
            }
            [vipString addAttribute:NSForegroundColorAttributeName value:SYColor(159, 105, 235) range:NSMakeRange(3, vipString.length - 3)];
            self.vipStatusInfoLabel.attributedText = vipString;
        }
    }];
    [[self.videoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.viewModel.user.userDiamond < 30) {
            [MBProgressHUD sy_showTips:@"当前用户钻石数量不足，无法发起视频通话"];
        } else {
            YYCache *cache = [YYCache cacheWithName:@"SeeYuHelper"];
            [cache setObject:self.viewModel.services.client.currentUserId forKey:@"videoUserId"];
            [cache setObject:self.viewModel.userId forKey:@"videoReceiveUserId"];
            [self.viewModel.sendVideoRequestCommand execute:self.viewModel.userId];
        }
    }];
}

- (void)_setupSubViews {
    UIImageView *avatarImageview = [UIImageView new];
    _avatarImageview = avatarImageview;
    [self.view addSubview:avatarImageview];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.font = SYRegularFont(14);
    aliasLabel.textColor = SYColor(255, 255, 255);
    _aliasLabel = aliasLabel;
    [self.view addSubview:aliasLabel];
    
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    signatureLabel.font = SYRegularFont(12);
    signatureLabel.textColor = SYColor(255, 255, 255);
    _signatureLabel = signatureLabel;
    [self.view addSubview:signatureLabel];
    
    UILabel *infoTipsLabel = [UILabel new];
    infoTipsLabel.textAlignment = NSTextAlignmentLeft;
    infoTipsLabel.font = SYRegularFont(16);
    infoTipsLabel.textColor = SYColor(51, 51, 51);
    infoTipsLabel.text = @"信息";
    _infoTipsLabel = infoTipsLabel;
    [self.view addSubview:infoTipsLabel];
    
    UILabel *aliasInfoLabel = [UILabel new];
    aliasInfoLabel.textAlignment = NSTextAlignmentLeft;
    aliasInfoLabel.font = SYRegularFont(13);
    _aliasInfoLabel = aliasInfoLabel;
    [self.view addSubview:aliasInfoLabel];
    
    UILabel *genderInfoLabel = [UILabel new];
    genderInfoLabel.textAlignment = NSTextAlignmentLeft;
    genderInfoLabel.font = SYRegularFont(13);
    _genderInfoLabel = genderInfoLabel;
    [self.view addSubview:genderInfoLabel];
    
    UILabel *ageInfoLabel = [UILabel new];
    ageInfoLabel.textAlignment = NSTextAlignmentLeft;
    ageInfoLabel.font = SYRegularFont(13);
    _ageInfoLabel = ageInfoLabel;
    [self.view addSubview:ageInfoLabel];
    
    UILabel *cityInfoLabel = [UILabel new];
    cityInfoLabel.textAlignment = NSTextAlignmentLeft;
    cityInfoLabel.font = SYRegularFont(13);
    _cityInfoLabel = cityInfoLabel;
    [self.view addSubview:cityInfoLabel];
    
    UILabel *heightInfoLabel = [UILabel new];
    heightInfoLabel.textAlignment = NSTextAlignmentLeft;
    heightInfoLabel.font = SYRegularFont(13);
    _heightInfoLabel = heightInfoLabel;
    [self.view addSubview:heightInfoLabel];
    
    UILabel *incomeInfoLabel = [UILabel new];
    incomeInfoLabel.textAlignment = NSTextAlignmentLeft;
    incomeInfoLabel.font = SYRegularFont(13);
    _incomeInfoLabel = incomeInfoLabel;
    [self.view addSubview:incomeInfoLabel];
    
    UILabel *jobInfoLabel = [UILabel new];
    jobInfoLabel.textAlignment = NSTextAlignmentLeft;
    jobInfoLabel.font = SYRegularFont(13);
    _jobInfoLabel = jobInfoLabel;
    [self.view addSubview:jobInfoLabel];
    
    // 爱好文本
    UILabel *hobbyInfoLabel = [UILabel new];
    hobbyInfoLabel.textAlignment = NSTextAlignmentLeft;
    hobbyInfoLabel.font = SYRegularFont(13);
    _hobbyInfoLabel = hobbyInfoLabel;
    [self.view addSubview:hobbyInfoLabel];
    
    // 生日文本
    UILabel *birthdayInfoLabel = [UILabel new];
    birthdayInfoLabel.textAlignment = NSTextAlignmentLeft;
    birthdayInfoLabel.font = SYRegularFont(13);
    _birthdayInfoLabel = birthdayInfoLabel;
    [self.view addSubview:birthdayInfoLabel];
    
    // 星座文本
    UILabel *constellationInfoLabel = [UILabel new];
    constellationInfoLabel.textAlignment = NSTextAlignmentLeft;
    constellationInfoLabel.font = SYRegularFont(13);
    _constellationInfoLabel = constellationInfoLabel;
    [self.view addSubview:constellationInfoLabel];
    
    // 婚姻文本
    UILabel *marryInfoLabel = [UILabel new];
    marryInfoLabel.textAlignment = NSTextAlignmentLeft;
    marryInfoLabel.font = SYRegularFont(13);
    _marryInfoLabel = marryInfoLabel;
    [self.view addSubview:marryInfoLabel];
    
    // 钻石文本
    UILabel *diamondsInfoLabel = [UILabel new];
    diamondsInfoLabel.textAlignment = NSTextAlignmentLeft;
    diamondsInfoLabel.font = SYRegularFont(13);
    _diamondsInfoLabel = diamondsInfoLabel;
    [self.view addSubview:diamondsInfoLabel];
    
    // 充值文本
    UILabel *rechargeInfoLabel = [UILabel new];
    rechargeInfoLabel.textAlignment = NSTextAlignmentLeft;
    rechargeInfoLabel.font = SYRegularFont(13);
    _rechargeInfoLabel = rechargeInfoLabel;
    [self.view addSubview:rechargeInfoLabel];
    
    // VIP文本
    UILabel *vipStatusInfoLabel = [UILabel new];
    vipStatusInfoLabel.textAlignment = NSTextAlignmentLeft;
    vipStatusInfoLabel.font = SYRegularFont(13);
    _vipStatusInfoLabel = vipStatusInfoLabel;
    [self.view addSubview:vipStatusInfoLabel];
    
    UIButton *videoBtn = [UIButton new];
    videoBtn.backgroundColor = SYColor(159, 105, 235);
    [videoBtn setTitle:@"发起视频" forState:UIControlStateNormal];
    [videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    videoBtn.titleLabel.font = SYRegularFont(18);
    _videoBtn = videoBtn;
    [self.view addSubview:videoBtn];
}

- (void)_makeSubViewsConstraints {
    [_avatarImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.offset(0.7 * SY_SCREEN_WIDTH);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.signatureLabel.mas_top).offset(-15);
        make.left.equalTo(self.avatarImageview).offset(15);
        make.height.offset(15);
    }];
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImageview).offset(-15);
        make.left.equalTo(self.avatarImageview).offset(15);
        make.height.offset(15);
    }];
    [_infoTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageview).offset(15);
        make.top.equalTo(self.avatarImageview.mas_bottom).offset(15);
        make.height.offset(20);
    }];
    [_aliasInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.infoTipsLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
    }];
    [_genderInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self.aliasInfoLabel);
        make.left.equalTo(self.view).offset(SY_SCREEN_WIDTH / 2);
    }];
    [_ageInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aliasInfoLabel.mas_bottom).offset(15);
        make.left.height.equalTo(self.aliasInfoLabel);
    }];
    [_cityInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self.ageInfoLabel);
        make.left.equalTo(self.genderInfoLabel);
    }];
    [_heightInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ageInfoLabel.mas_bottom).offset(15);
        make.left.height.equalTo(self.aliasInfoLabel);
    }];
    [_incomeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self.heightInfoLabel);
        make.left.equalTo(self.cityInfoLabel);
    }];
    [_jobInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heightInfoLabel.mas_bottom).offset(15);
        make.left.height.equalTo(self.heightInfoLabel);
    }];
    [_hobbyInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self.jobInfoLabel);
        make.left.equalTo(self.incomeInfoLabel);
    }];
    [_birthdayInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jobInfoLabel.mas_bottom).offset(15);
        make.left.height.equalTo(self.jobInfoLabel);
    }];
    [_constellationInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self.birthdayInfoLabel);
        make.left.equalTo(self.hobbyInfoLabel);
    }];
    [_marryInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthdayInfoLabel.mas_bottom).offset(15);
        make.left.height.equalTo(self.birthdayInfoLabel);
    }];
    [_diamondsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self.marryInfoLabel);
        make.left.equalTo(self.constellationInfoLabel);
    }];
    [_rechargeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.marryInfoLabel.mas_bottom).offset(15);
        make.left.height.equalTo(self.marryInfoLabel);
    }];
    [_vipStatusInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self.rechargeInfoLabel);
        make.left.equalTo(self.diamondsInfoLabel);
    }];
    [_videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
}

@end
