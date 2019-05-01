//
//  SYRegisterView.m
//  SeeYu
//
//  Created by 唐荣才 on 2018/12/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "SYRegisterView.h"

@interface SYRegisterView ()

/// 昵称文本
@property(nonatomic, weak) UILabel *aliasLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine1;

/// 年龄文本
@property(nonatomic, weak) UILabel *ageLabel;

/// 岁
@property(nonatomic, weak) UILabel *ageStringlabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine2;

/// 性别文本
@property(nonatomic, weak) UILabel *genderLabel;

@property(nonatomic, weak) UIView *chooseMaleView;

@property(nonatomic, weak) UIView *chooseFemaleView;

/// 职业文本
@property(nonatomic, weak) UILabel *jobLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine3;

/// 收入文本
@property(nonatomic, weak) UILabel *incomeLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine4;

/// 身高文本
@property(nonatomic, weak) UILabel *heightLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine5;

/// 婚姻文本
@property(nonatomic, weak) UILabel *maritalStatusLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine6;

@property(nonatomic, weak) UIScrollView *scrollView;

@end

@implementation SYRegisterView

+ (instancetype)registerView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 添加子控件
        [self _setupSubViews];
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 添加子控件
- (void)_setupSubViews {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.contentSize = CGSizeMake(SY_SCREEN_WIDTH, 535);
    _scrollView = scrollView;
    [self addSubview:scrollView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.text = @"昵称";
    aliasLabel.textColor = SYColor(153, 153, 153);
    aliasLabel.font = SYRegularFont(18);
    _aliasLabel = aliasLabel;
    [scrollView addSubview:aliasLabel];
    
    UITextField *aliasTextField = [[UITextField alloc]init];
    aliasTextField.font = SYRegularFont(20);
    aliasTextField.textColor = SYColor(51, 51, 51);
    [aliasTextField sy_limitMaxLength:SYNicknameMaxWords];
    _aliasTextField = aliasTextField;
    [scrollView addSubview:_aliasTextField];
    
    UIImageView *underLine1 = [[UIImageView alloc]init];
    underLine1.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine1 = underLine1;
    [scrollView addSubview:underLine1];
    
    UILabel *ageLabel = [[UILabel alloc]init];
    ageLabel.text = @"年龄";
    ageLabel.textColor = SYColor(153, 153, 153);
    ageLabel.font = SYRegularFont(18);
    _ageLabel = ageLabel;
    [scrollView addSubview:ageLabel];
    
    UIButton *ageBtn = [[UIButton alloc]init];
    ageBtn.titleLabel.font = SYRegularFont(20);
    [ageBtn setTitleColor:SYColor(51, 51, 51) forState:UIControlStateNormal];
    ageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    ageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _ageBtn = ageBtn;
    [scrollView addSubview:ageBtn];
    
    UILabel *ageStringlabel = [UILabel new];
    ageStringlabel.text = @"岁";
    ageStringlabel.textColor = [UIColor blackColor];
    ageStringlabel.font = SYRegularFont(18);
    _ageStringlabel = ageStringlabel;
    [scrollView addSubview:ageStringlabel];
    
    UIImageView *underLine2 = [[UIImageView alloc]init];
    underLine2.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine2 = underLine2;
    [scrollView addSubview:underLine2];
    
    UILabel *genderLabel = [[UILabel alloc]init];
    genderLabel.text = @"性别";
    genderLabel.textColor = SYColor(153, 153, 153);
    genderLabel.font = SYRegularFont(18);
    _genderLabel = genderLabel;
    [scrollView addSubview:genderLabel];
    
    UIButton *maleBtn = [[UIButton alloc]init];
    [maleBtn setBackgroundImage:SYImageNamed(@"reg_sex_male_normal") forState:UIControlStateNormal];
    [maleBtn setBackgroundImage:SYImageNamed(@"reg_sex_male_pressed") forState:UIControlStateSelected];
    maleBtn.selected = YES;
    _maleBtn = maleBtn;
    [scrollView addSubview:_maleBtn];
    
    UILabel *maleLabel = [[UILabel alloc]init];
    maleLabel.text = @"男";
    maleLabel.textColor = SYColor(196, 145, 253);
    maleLabel.font = SYRegularFont(20);
    _maleLabel = maleLabel;
    [scrollView addSubview:maleLabel];
    
    UIView *chooseMaleView = [UIView new];
    _chooseMaleView = chooseMaleView;
    [scrollView addSubview:chooseMaleView];
    _chooseMaleTap = [UITapGestureRecognizer new];
    [chooseMaleView addGestureRecognizer:_chooseMaleTap];
    
    UIButton *femaleBtn = [[UIButton alloc]init];
    [femaleBtn setBackgroundImage:SYImageNamed(@"reg_sex_female_normal") forState:UIControlStateNormal];
    [femaleBtn setBackgroundImage:SYImageNamed(@"reg_sex_female_pressed") forState:UIControlStateSelected];
    _femaleBtn = femaleBtn;
    [scrollView addSubview:_femaleBtn];
    
    UILabel *femaleLabel = [[UILabel alloc]init];
    femaleLabel.text = @"女";
    femaleLabel.textColor = SYColor(153, 153, 153);
    femaleLabel.font = SYRegularFont(20);
    _femaleLabel = femaleLabel;
    [scrollView addSubview:femaleLabel];
    
    UIView *chooseFemaleView = [UIView new];
    _chooseFemaleView = chooseFemaleView;
    [scrollView addSubview:chooseFemaleView];
    _chooseFemaleTap = [UITapGestureRecognizer new];
    [chooseFemaleView addGestureRecognizer:_chooseFemaleTap];
    
    // 职业
    UILabel *jobLabel = [[UILabel alloc]init];
    jobLabel.text = @"职业";
    jobLabel.textColor = SYColor(153, 153, 153);
    jobLabel.font = SYRegularFont(18);
    _jobLabel = jobLabel;
    [scrollView addSubview:jobLabel];
    
    UIButton *jobBtn = [[UIButton alloc]init];
    jobBtn.titleLabel.font = SYRegularFont(20);
    [jobBtn setTitleColor:SYColor(51, 51, 51) forState:UIControlStateNormal];
    jobBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    jobBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _jobBtn = jobBtn;
    [scrollView addSubview:jobBtn];
    
    UIImageView *underLine3 = [[UIImageView alloc]init];
    underLine3.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine3 = underLine3;
    [scrollView addSubview:underLine3];
    
    UILabel *incomeLabel = [[UILabel alloc]init];
    incomeLabel.text = @"收入";
    incomeLabel.textColor = SYColor(153, 153, 153);
    incomeLabel.font = SYRegularFont(18);
    _incomeLabel = incomeLabel;
    [scrollView addSubview:incomeLabel];
    
    UIButton *incomeBtn = [[UIButton alloc]init];
    incomeBtn.titleLabel.font = SYRegularFont(20);
    [incomeBtn setTitleColor:SYColor(51, 51, 51) forState:UIControlStateNormal];
    incomeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    incomeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _incomeBtn = incomeBtn;
    [scrollView addSubview:incomeBtn];
    
    UIImageView *underLine4 = [[UIImageView alloc]init];
    underLine4.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine4 = underLine4;
    [scrollView addSubview:underLine4];
    
    UILabel *heightLabel = [[UILabel alloc]init];
    heightLabel.text = @"身高";
    heightLabel.textColor = SYColor(153, 153, 153);
    heightLabel.font = SYRegularFont(18);
    _heightLabel = heightLabel;
    [scrollView addSubview:heightLabel];
    
    UIButton *heightBtn = [[UIButton alloc]init];
    heightBtn.titleLabel.font = SYRegularFont(20);
    [heightBtn setTitleColor:SYColor(51, 51, 51) forState:UIControlStateNormal];
    heightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    heightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _heightBtn = heightBtn;
    [scrollView addSubview:heightBtn];
    
    UIImageView *underLine5 = [[UIImageView alloc]init];
    underLine5.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine5 = underLine5;
    [scrollView addSubview:underLine5];
    
    UILabel *maritalStatusLabel = [[UILabel alloc]init];
    maritalStatusLabel.textColor = SYColor(153, 153, 153);
    maritalStatusLabel.font = SYRegularFont(18);
    maritalStatusLabel.text = @"婚姻";
    _maritalStatusLabel = maritalStatusLabel;
    [scrollView addSubview:maritalStatusLabel];
    
    UIButton *maritalStatusBtn = [[UIButton alloc]init];
    maritalStatusBtn.titleLabel.font = SYRegularFont(20);
    [maritalStatusBtn setTitleColor:SYColor(51, 51, 51) forState:UIControlStateNormal];
    maritalStatusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    maritalStatusBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _maritalStatusBtn = maritalStatusBtn;
    [scrollView addSubview:maritalStatusBtn];
    
    UIImageView *underLine6 = [[UIImageView alloc]init];
    underLine6.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine6 = underLine6;
    [scrollView addSubview:underLine6];
    
    UIButton *completeBtn = [[UIButton alloc]init];
    [completeBtn setBackgroundImage:[UIImage yy_imageWithColor:SYColorFromHexString(@"#9F69EB")] forState:UIControlStateNormal];
    completeBtn.titleLabel.font = SYRegularFont(20);
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTintColor:SYColorFromHexString(@"#FFFFFF")];
    completeBtn.tag = 801;
    _completeBtn = completeBtn;
    [self addSubview:completeBtn];
}

#pragma mark - 添加控件约束
- (void)_makeSubViewsConstraints {
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(50);
        make.top.equalTo(self.scrollView).offset(45);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_aliasTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.aliasLabel);
        make.right.equalTo(self).offset(-50);
        make.left.equalTo(self.aliasLabel.mas_right).offset(30);
    }];
    [_underLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliasLabel);
        make.right.equalTo(self.aliasTextField);
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(15);
        make.height.offset(1);
    }];
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliasLabel);
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_ageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.aliasTextField);
        make.centerY.equalTo(self.ageLabel);
        make.width.offset(50);
    }];
    [_ageStringlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageBtn.mas_right);
        make.centerY.height.equalTo(self.ageLabel);
        make.right.equalTo(self).offset(-50);
    }];
    [_underLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageLabel);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.ageLabel.mas_bottom).offset(15);
        make.height.offset(1);
    }];
    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliasLabel);
        make.top.equalTo(self.ageLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.left.equalTo(self.genderLabel.mas_right).offset(30);
        make.centerY.equalTo(self.genderLabel);
    }];
    [_maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maleBtn.mas_right).offset(15);
        make.width.height.offset(25);
        make.centerY.equalTo(self.genderLabel);
    }];
    [_chooseMaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.maleBtn);
        make.left.equalTo(self.maleBtn);
        make.right.equalTo(self.maleLabel);
    }];
    [_femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.left.equalTo(self.maleLabel.mas_right).offset(45);
        make.centerY.equalTo(self.genderLabel);
    }];
    [_femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.femaleBtn.mas_right).offset(15);
        make.width.height.offset(25);
        make.centerY.equalTo(self.genderLabel);
    }];
    [_chooseFemaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.femaleBtn);
        make.left.equalTo(self.femaleBtn);
        make.right.equalTo(self.femaleLabel);
    }];
    [_jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.genderLabel);
        make.top.equalTo(self.genderLabel.mas_bottom).offset(40);
    }];
    [_jobBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.jobLabel);
        make.right.equalTo(self).offset(-50);
        make.left.equalTo(self.jobLabel.mas_right).offset(30);
    }];
    [_underLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jobLabel);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.jobLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jobLabel);
        make.top.equalTo(self.jobLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_incomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.incomeLabel);
        make.right.equalTo(self).offset(-50);
        make.left.equalTo(self.incomeLabel.mas_right).offset(30);
    }];
    [_underLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeLabel);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.incomeLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeLabel);
        make.top.equalTo(self.incomeLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_heightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.heightLabel);
        make.right.equalTo(self).offset(-50);
        make.left.equalTo(self.heightLabel.mas_right).offset(30);
    }];
    [_underLine5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heightLabel);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.heightLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    [_maritalStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heightLabel);
        make.top.equalTo(self.heightLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_maritalStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maritalStatusLabel.mas_right).offset(30);
        make.top.height.equalTo(self.maritalStatusLabel);
        make.right.equalTo(self).offset(-50);
    }];
    [_underLine6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maritalStatusLabel);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.maritalStatusLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.offset(49);
    }];
}

@end
