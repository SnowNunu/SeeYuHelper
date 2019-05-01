//
//  SYBaseInfoDetailVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYBaseInfoDetailVC.h"
#import "SYUserInfoEditModel.h"

@interface SYBaseInfoDetailVC ()

@property (nonatomic, strong) UIView *infoBgView;

@property (nonatomic, strong) UILabel *signatureLabel;

@property (nonatomic, strong) UILabel *aliasLabel;

@property (nonatomic, strong) UILabel *genderLabel;

@property (nonatomic, strong) UILabel *ageLabel;

@property (nonatomic, strong) UILabel *birthdayLabel;

@property (nonatomic, strong) UILabel *heightLabel;

@property (nonatomic, strong) UILabel *weightLabel;

@property (nonatomic, strong) UILabel *marryLabel;

@property (nonatomic, strong) UILabel *eduLabel;

@property (nonatomic, strong) UILabel *jobLabel;

@property (nonatomic, strong) UILabel *incomeLabel;

@property (nonatomic, strong) UILabel *constellationLabel;

@property (nonatomic, strong) UILabel *hobbyLabel;

@property (nonatomic, strong) UIButton *modifyBtn;

@end

@implementation SYBaseInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestUserShowInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        if (![user sy_isNullOrNil]) {
            // 签名
            if (![user.userSignature sy_isNullOrNil] && user.userSignature.length > 0) {
                self.signatureLabel.text = [NSString stringWithFormat:@"签名：%@",user.userSignature];
            } else {
                self.signatureLabel.text = @"签名：";
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
            self.aliasLabel.attributedText = aliasString;
            // 性别
            NSMutableAttributedString *genderString;
            if (![user.userGender sy_isNullOrNil] && user.userGender.length > 0) {
                genderString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"性别：%@",user.userGender]];
                [genderString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, genderString.length - 3)];
            } else {
                genderString = [[NSMutableAttributedString alloc] initWithString:@"性别：未填写"];
                [genderString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, genderString.length - 3)];
            }
            self.genderLabel.attributedText = genderString;
            // 年龄
            NSMutableAttributedString *ageString;
            if (![user.userAge sy_isNullOrNil] && user.userAge.length > 0) {
                ageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"年龄：%@",user.userAge]];
                [ageString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, ageString.length - 3)];
            } else {
                ageString = [[NSMutableAttributedString alloc] initWithString:@"年龄：未填写"];
                [ageString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, ageString.length - 3)];
            }
            self.ageLabel.attributedText = ageString;
            // 生日
            NSMutableAttributedString *birthdayString;
            if (![user.userBirthday sy_isNullOrNil] && user.userBirthday.length > 0) {
                birthdayString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"生日：%@",user.userBirthday]];
                [birthdayString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, birthdayString.length - 3)];
            } else {
                birthdayString = [[NSMutableAttributedString alloc] initWithString:@"生日：未填写"];
                [birthdayString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, birthdayString.length - 3)];
            }
            self.birthdayLabel.attributedText = birthdayString;
            // 身高
            NSMutableAttributedString *heightString;
            if (![user.userHeight sy_isNullOrNil] && user.userHeight.length > 0) {
                heightString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"身高：%@",user.userHeight]];
                [heightString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, heightString.length - 3)];
            } else {
                heightString = [[NSMutableAttributedString alloc] initWithString:@"身高：未填写"];
                [heightString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, heightString.length - 3)];
            }
            self.heightLabel.attributedText = heightString;
            // 体重
            NSMutableAttributedString *weightString;
            if (![user.userWeight sy_isNullOrNil] && user.userWeight.length > 0) {
                weightString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"体重：%@",user.userWeight]];
                [weightString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, weightString.length - 3)];
            } else {
                weightString = [[NSMutableAttributedString alloc] initWithString:@"体重：未填写"];
                [weightString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, weightString.length - 3)];
            }
            self.weightLabel.attributedText = weightString;
            // 婚姻
            NSMutableAttributedString *marryString;
            if (![user.userMarry sy_isNullOrNil] && user.userMarry.length > 0) {
                marryString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"婚姻：%@",user.userMarry]];
                [marryString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, marryString.length - 3)];
            } else {
                marryString = [[NSMutableAttributedString alloc] initWithString:@"婚姻：未填写"];
                [marryString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, marryString.length - 3)];
            }
            self.marryLabel.attributedText = marryString;
            // 学历
            NSMutableAttributedString *eduString;
            if (![user.userEdu sy_isNullOrNil] && user.userEdu.length > 0) {
                eduString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"学历：%@",user.userEdu]];
                [eduString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, eduString.length - 3)];
            } else {
                eduString = [[NSMutableAttributedString alloc] initWithString:@"学历：未填写"];
                [eduString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, eduString.length - 3)];
            }
            self.eduLabel.attributedText = eduString;
            // 职业
            NSMutableAttributedString *jobString;
            if (![user.userProfession sy_isNullOrNil] && user.userProfession.length > 0) {
                jobString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"职业：%@",user.userProfession]];
                [jobString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, jobString.length - 3)];
            } else {
                jobString = [[NSMutableAttributedString alloc] initWithString:@"职业：未填写"];
                [jobString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, jobString.length - 3)];
            }
            self.jobLabel.attributedText = jobString;
            // 收入
            NSMutableAttributedString *incomeString;
            if (![user.userIncome sy_isNullOrNil] && user.userIncome.length > 0) {
                incomeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收入：%@",user.userIncome]];
                [incomeString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, incomeString.length - 3)];
            } else {
                incomeString = [[NSMutableAttributedString alloc] initWithString:@"收入：未填写"];
                [incomeString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, incomeString.length - 3)];
            }
            self.incomeLabel.attributedText = incomeString;
            // 星座
            NSMutableAttributedString *constellationString;
            if (![user.userConstellation sy_isNullOrNil] && user.userConstellation.length > 0) {
                constellationString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"星座：%@",user.userConstellation]];
                [constellationString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, constellationString.length - 3)];
            } else {
                constellationString = [[NSMutableAttributedString alloc] initWithString:@"星座：未填写"];
                [constellationString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, constellationString.length - 3)];
            }
            self.constellationLabel.attributedText = constellationString;
            // 爱好
            NSMutableAttributedString *hobbytring;
            if (![user.userSpecialty sy_isNullOrNil] && user.userSpecialty.length > 0) {
                hobbytring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"爱好：%@",user.userSpecialty]];
                [hobbytring addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, hobbytring.length - 3)];
            } else {
                hobbytring = [[NSMutableAttributedString alloc] initWithString:@"爱好：未填写"];
                [hobbytring addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, hobbytring.length - 3)];
            }
            self.hobbyLabel.attributedText = hobbytring;
        }
    }];
    self.modifyBtn.rac_command = self.viewModel.enterInfoEditViewCommand;
}

- (void)_setupSubviews {
    self.view.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    
    UIView *infoBgView = [UIView new];
    infoBgView.backgroundColor = [UIColor whiteColor];
    _infoBgView = infoBgView;
    [self.view addSubview:infoBgView];
    
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    signatureLabel.font = SYRegularFont(14);
    signatureLabel.text = @"签名:";
    _signatureLabel = signatureLabel;
    [infoBgView addSubview:signatureLabel];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.font = SYRegularFont(13);
    aliasLabel.text = @"昵称:";
    _aliasLabel = aliasLabel;
    [infoBgView addSubview:aliasLabel];
    
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentLeft;
    genderLabel.font = SYRegularFont(13);
    genderLabel.text = @"性别：";
    _genderLabel = genderLabel;
    [infoBgView addSubview:genderLabel];
    
    UILabel *ageLabel = [UILabel new];
    ageLabel.textAlignment = NSTextAlignmentLeft;
    ageLabel.font = SYRegularFont(13);
    ageLabel.text = @"年龄:";
    _ageLabel = ageLabel;
    [infoBgView addSubview:ageLabel];
    
    UILabel *birthdayLabel = [UILabel new];
    birthdayLabel.textAlignment = NSTextAlignmentLeft;
    birthdayLabel.font = SYRegularFont(13);
    birthdayLabel.text = @"生日：";
    _birthdayLabel = birthdayLabel;
    [infoBgView addSubview:birthdayLabel];
    
    UILabel *heightLabel = [UILabel new];
    heightLabel.textAlignment = NSTextAlignmentLeft;
    heightLabel.font = SYRegularFont(13);
    heightLabel.text = @"身高:";
    _heightLabel = heightLabel;
    [infoBgView addSubview:heightLabel];
    
    UILabel *weightLabel = [UILabel new];
    weightLabel.textAlignment = NSTextAlignmentLeft;
    weightLabel.font = SYRegularFont(13);
    weightLabel.text = @"体重：";
    _weightLabel = weightLabel;
    [infoBgView addSubview:weightLabel];
    
    UILabel *marryLabel = [UILabel new];
    marryLabel.textAlignment = NSTextAlignmentLeft;
    marryLabel.font = SYRegularFont(13);
    marryLabel.text = @"婚姻:";
    _marryLabel = marryLabel;
    [infoBgView addSubview:marryLabel];
    
    UILabel *eduLabel = [UILabel new];
    eduLabel.textAlignment = NSTextAlignmentLeft;
    eduLabel.font = SYRegularFont(13);
    eduLabel.text = @"学历：";
    _eduLabel = eduLabel;
    [infoBgView addSubview:eduLabel];
    
    UILabel *jobLabel = [UILabel new];
    jobLabel.textAlignment = NSTextAlignmentLeft;
    jobLabel.font = SYRegularFont(13);
    jobLabel.text = @"职业:";
    _jobLabel = jobLabel;
    [infoBgView addSubview:jobLabel];
    
    UILabel *incomeLabel = [UILabel new];
    incomeLabel.textAlignment = NSTextAlignmentLeft;
    incomeLabel.font = SYRegularFont(13);
    incomeLabel.text = @"收入：";
    _incomeLabel = incomeLabel;
    [infoBgView addSubview:incomeLabel];
    
    UILabel *constellationLabel = [UILabel new];
    constellationLabel.textAlignment = NSTextAlignmentLeft;
    constellationLabel.font = SYRegularFont(13);
    constellationLabel.text = @"星座:";
    _constellationLabel = constellationLabel;
    [infoBgView addSubview:constellationLabel];
    
    UILabel *hobbyLabel = [UILabel new];
    hobbyLabel.textAlignment = NSTextAlignmentLeft;
    hobbyLabel.font = SYRegularFont(13);
    hobbyLabel.text = @"爱好：";
    _hobbyLabel = hobbyLabel;
    [infoBgView addSubview:hobbyLabel];
    
    UIButton *modifyBtn = [UIButton new];
    [modifyBtn setTitle:@"修改资料" forState:UIControlStateNormal];
    [modifyBtn setTintColor:[UIColor whiteColor]];
    modifyBtn.titleLabel.font = SYRegularFont(19);
    modifyBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    _modifyBtn = modifyBtn;
    [self.view addSubview:modifyBtn];
}

- (void)_makeSubViewsConstraints {
    [_infoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.constellationLabel.mas_bottom).offset(30);
    }];
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoBgView).offset(30);
        make.left.equalTo(self.infoBgView).offset(15);
        make.height.offset(15);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.signatureLabel);
        make.top.equalTo(self.signatureLabel.mas_bottom).offset(30);
    }];
    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBgView).offset(SY_SCREEN_WIDTH / 2);
        make.top.height.equalTo(self.aliasLabel);
    }];
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.aliasLabel);
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(15);
    }];
    [_birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBgView).offset(SY_SCREEN_WIDTH / 2);
        make.top.height.equalTo(self.ageLabel);
    }];
    [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.ageLabel);
        make.top.equalTo(self.ageLabel.mas_bottom).offset(15);
    }];
    [_weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBgView).offset(SY_SCREEN_WIDTH / 2);
        make.top.height.equalTo(self.heightLabel);
    }];
    [_marryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.heightLabel);
        make.top.equalTo(self.heightLabel.mas_bottom).offset(15);
    }];
    [_eduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBgView).offset(SY_SCREEN_WIDTH / 2);
        make.top.height.equalTo(self.marryLabel);
    }];
    [_jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.marryLabel);
        make.top.equalTo(self.marryLabel.mas_bottom).offset(15);
    }];
    [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBgView).offset(SY_SCREEN_WIDTH / 2);
        make.top.height.equalTo(self.jobLabel);
    }];
    [_constellationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.jobLabel);
        make.top.equalTo(self.jobLabel.mas_bottom).offset(15);
    }];
    [_hobbyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBgView).offset(SY_SCREEN_WIDTH / 2);
        make.top.height.equalTo(self.constellationLabel);
    }];
    [_modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.offset(40);
    }];
}

@end
