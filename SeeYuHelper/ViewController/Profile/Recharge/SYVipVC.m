//
//  SYVipVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVipVC.h"

@interface SYVipVC ()

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *advImageView;

@property (nonatomic, strong) UIButton *vip99Btn;

@property (nonatomic, strong) UIButton *vip98Btn;

@property (nonatomic, strong) UIButton *vip68Btn;

@property (nonatomic, strong) UIView *vipRightsView;

@property (nonatomic, strong) UILabel *vipRightsLabel;

@property (nonatomic, strong) UIView *vipRechargeView;

@property (nonatomic, strong) UILabel *vipRechargeLabel;

@property (nonatomic, strong) UILabel *vipRechargeTipsLabel;

@property (nonatomic ,strong) NSArray *rightImagesArray;

@property (nonatomic ,strong) NSArray *rightTextsArray;

@end

@implementation SYVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _rightImagesArray = @[@"vip_icon_seeDetail",@"vip_icon_video",@"vip_icon_crown",@"vop_icon_anchorPower",@"vip_icon_quickmatch"];
    _rightTextsArray = @[@"私密阅览",@"视频畅聊",@"尊贵标识",@"主播权利",@"速配特权"];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat width = (SY_SCREEN_WIDTH - 15 * 6) / 5;
    _scrollView.contentSize = CGSizeMake(SY_SCREEN_WIDTH, 600 + width);
}

- (void)_setupSubViews {
    CGFloat width = (SY_SCREEN_WIDTH - 15 * 6) / 5;
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIImageView *advImageView = [UIImageView new];
    advImageView.image = SYImageNamed(@"banner_vip");
    _advImageView = advImageView;
    [scrollView addSubview:advImageView];
    
    UIButton *vip99Btn = [UIButton new];
    [vip99Btn setImage:SYImageNamed(@"vip_99") forState:UIControlStateNormal];
    _vip99Btn = vip99Btn;
    [scrollView addSubview:vip99Btn];
    
    UIButton *vip98Btn = [UIButton new];
    [vip98Btn setImage:SYImageNamed(@"vip_98") forState:UIControlStateNormal];
    _vip98Btn = vip98Btn;
    [scrollView addSubview:vip98Btn];
    
    UIButton *vip68Btn = [UIButton new];
    [vip68Btn setImage:SYImageNamed(@"vip_68") forState:UIControlStateNormal];
    _vip68Btn = vip68Btn;
    [scrollView addSubview:vip68Btn];
    
    UIView *vipRightsView = [UIView new];
    vipRightsView.backgroundColor = [UIColor whiteColor];
    _vipRightsView = vipRightsView;
    [scrollView addSubview:vipRightsView];
    
    UILabel *vipRightsLabel = [UILabel new];
    vipRightsLabel.textColor = SYColor(51, 51, 51);
    vipRightsLabel.textAlignment = NSTextAlignmentLeft;
    vipRightsLabel.font = SYRegularFont(14);
    vipRightsLabel.text = @"会员特权";
    _vipRightsLabel = vipRightsLabel;
    [vipRightsView addSubview:vipRightsLabel];
    
    for (int i = 0; i < 5; i++) {
        UIImageView *rightImageView = [UIImageView new];
        rightImageView.image = SYImageNamed(_rightImagesArray[i]);
        [vipRightsView addSubview:rightImageView];
        UILabel *rightLabel = [UILabel new];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.textColor = SYColor(51, 51, 51);
        rightLabel.font = SYRegularFont(10);
        rightLabel.text = _rightTextsArray[i];
        [vipRightsView addSubview:rightLabel];
        
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(width);
            make.top.equalTo(vipRightsLabel.mas_bottom).offset(15);
            make.left.equalTo(vipRightsView).offset(15 + i * (width + 15));
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rightImageView);
            make.height.offset(20);
            make.top.equalTo(rightImageView.mas_bottom).offset(15);
        }];
    }
    
    UIView *vipRechargeView = [UIView new];
    vipRechargeView.backgroundColor = [UIColor whiteColor];
    _vipRechargeView = vipRechargeView;
    [scrollView addSubview:vipRechargeView];
    
    UILabel *vipRechargeLabel = [UILabel new];
    vipRechargeLabel.textColor = SYColor(51, 51, 51);
    vipRechargeLabel.textAlignment = NSTextAlignmentLeft;
    vipRechargeLabel.font = SYRegularFont(13);
    vipRechargeLabel.text = @"充值活动";
    _vipRechargeLabel = vipRechargeLabel;
    [vipRechargeView addSubview:vipRechargeLabel];
    
    UILabel *vipRechargeTipsLabel = [UILabel new];
    vipRechargeTipsLabel.textColor = SYColor(51, 51, 51);
    vipRechargeTipsLabel.font = SYRegularFont(12);
    vipRechargeTipsLabel.text = @"1.充值话费目前仅限中国移动，中国联通及中国电信。\n2.话费领取：请于充值后联系红娘客服获取话费。";
    vipRechargeTipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    vipRechargeTipsLabel.numberOfLines = 0;
    _vipRechargeTipsLabel = vipRechargeTipsLabel;
    [vipRechargeView addSubview:vipRechargeTipsLabel];
}

- (void)_makeSubViewsConstraints {
    CGFloat height = (SY_SCREEN_WIDTH - 15 * 6) / 5;
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_advImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.scrollView);
        make.width.offset(SY_SCREEN_WIDTH);
        make.height.offset(140);
    }];
    [_vip99Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.scrollView);
        make.height.offset(60);
        make.top.equalTo(self.advImageView.mas_bottom).offset(15);
    }];
    [_vip98Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.scrollView);
        make.height.offset(60);
        make.top.equalTo(self.vip99Btn.mas_bottom).offset(15);
    }];
    [_vip68Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.scrollView);
        make.height.offset(60);
        make.top.equalTo(self.vip98Btn.mas_bottom).offset(15);
    }];
    [_vipRightsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.top.equalTo(self.vip68Btn.mas_bottom).offset(15);
        make.height.offset(height + 115);
    }];
    [_vipRightsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.vipRightsView).offset(15);
        make.top.equalTo(self.vipRightsView).offset(15);
    }];
    [_vipRechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.top.equalTo(self.vipRightsView.mas_bottom).offset(15);
        make.height.offset(105);
    }];
    [_vipRechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.vipRechargeView).offset(15);
        make.top.equalTo(self.vipRechargeView).offset(15);
    }];
    [_vipRechargeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vipRechargeLabel.mas_bottom).offset(15);
        make.left.equalTo(self.vipRechargeView).offset(15);
        make.right.equalTo(self.vipRechargeView).offset(-15);
        make.height.offset(40);
    }];
}

@end
