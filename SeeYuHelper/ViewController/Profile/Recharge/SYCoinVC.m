//
//  SYCoinVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYCoinVC.h"

@interface SYCoinVC ()

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *advImageView;

@property (nonatomic, strong) UIView *chatCoinsView;

@property (nonatomic, strong) UILabel *chatCoinsLabel;

@property (nonatomic, strong) UILabel *chatCoinsAmountLabel;

@property (nonatomic, strong) UIView *buyersView;

@property (nonatomic, strong) UILabel *buyersLabel;

@property (nonatomic ,strong) TXScrollLabelView *buyersShowView;

@property (nonatomic, strong) UIButton *coin100Btn;

@property (nonatomic, strong) UIButton *coin65Btn;

@property (nonatomic, strong) UIView *coinRightsView;

@property (nonatomic, strong) UILabel *coinRightsLabel;

@property (nonatomic, strong) UIView *coinPriceView;

@property (nonatomic, strong) UILabel *coinPriceLabel;

@property (nonatomic, strong) UILabel *coinPriceDetailLabel;

@property (nonatomic, strong) UIView *coinActivityView;

@property (nonatomic, strong) UILabel *coinActivityLabel;

@property (nonatomic, strong) UILabel *coinActivityDetailLabel;

@property (nonatomic ,strong) NSArray *rightImagesArray;

@property (nonatomic ,strong) NSArray *rightTextsArray;

@end

@implementation SYCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _rightImagesArray = @[@"vip_icon_video",@"vip_icon_quickmatch",@"bCoin_icon_chat"];
    _rightTextsArray = @[@"私密视频",@"无限速配",@"美女畅聊"];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _scrollView.contentSize = CGSizeMake(SY_SCREEN_WIDTH, 837);
    [_buyersShowView beginScrolling];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve( self.viewModel, user) subscribeNext:^(SYUser *user) {
        if (user.userCoin > 0) {
            self.chatCoinsAmountLabel.text = [NSString stringWithFormat:@"%d",user.userCoin];
        }
    }];
}

- (void)_setupSubViews {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIImageView *advImageView = [UIImageView new];
    advImageView.image = SYImageNamed(@"banner_coin");
    _advImageView = advImageView;
    [scrollView addSubview:advImageView];
    
    UIView *chatCoinsView = [UIView new];
    chatCoinsView.backgroundColor = [UIColor whiteColor];
    _chatCoinsView = chatCoinsView;
    [scrollView addSubview:chatCoinsView];
    
    UILabel *chatCoinsLabel = [UILabel new];
    chatCoinsLabel.textAlignment = NSTextAlignmentLeft;
    chatCoinsLabel.font = SYRegularFont(15);
    chatCoinsLabel.textColor = SYColor(51, 51, 51);
    chatCoinsLabel.text = @"我的聊豆";
    _chatCoinsLabel = chatCoinsLabel;
    [chatCoinsView addSubview:chatCoinsLabel];
    
    UILabel *chatCoinsAmountLabel = [UILabel new];
    chatCoinsAmountLabel.textAlignment = NSTextAlignmentLeft;
    chatCoinsAmountLabel.font = SYRegularFont(15);
    chatCoinsAmountLabel.textColor = SYColor(230, 0, 18);
    chatCoinsAmountLabel.text = @"0";
    _chatCoinsAmountLabel = chatCoinsAmountLabel;
    [chatCoinsView addSubview:chatCoinsAmountLabel];
    
    UIView *buyersView = [UIView new];
    buyersView.backgroundColor = [UIColor whiteColor];
    _buyersView = buyersView;
    [scrollView addSubview:buyersView];
    
    UILabel *buyersLabel = [UILabel new];
    buyersLabel.textAlignment = NSTextAlignmentLeft;
    buyersLabel.font = SYRegularFont(12);
    buyersLabel.textColor = SYColor(51, 51, 51);
    buyersLabel.text = @"已有：465214人购买";
    _buyersLabel = buyersLabel;
    [buyersView addSubview:buyersLabel];
    
    NSArray *mobilesArray = @[@"152******97",
                             @"138******10",
                             @"158******88",
                             @"188******21",
                             @"139******35",
                             @"186******40",
                             @"132******77",
                             @"180******56",
                             @"131******28",
                             @"189******34"];
    NSMutableAttributedString *tips = [NSMutableAttributedString new];
    for (int i = 0; i < 10; i ++) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"手机号为%@的用户已成功获得100元话费\n",mobilesArray[i]]];
        [str addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(18, 11)];
        [tips appendAttributedString:str];
    }
    TXScrollLabelView *buyersShowView = [TXScrollLabelView scrollWithTitle:@"" type:TXScrollLabelViewTypeUpDown velocity:3 options:UIViewAnimationOptionCurveEaseInOut];
    buyersShowView.textAlignment = NSTextAlignmentLeft;
    buyersShowView.font = SYRegularFont(12);
    buyersShowView.backgroundColor = [UIColor clearColor];
    buyersShowView.scrollTitleColor = [UIColor blackColor];
    [buyersShowView setupAttributeTitle:tips];
    buyersShowView.frame = CGRectMake(15, 35, SY_SCREEN_WIDTH - 30, 40);
    _buyersShowView = buyersShowView;
    [buyersView addSubview:buyersShowView];
    
    UIButton *coin100Btn = [UIButton new];
    [coin100Btn setImage:SYImageNamed(@"bCoin_100") forState:UIControlStateNormal];
    _coin100Btn = coin100Btn;
    [scrollView addSubview:coin100Btn];
    
    UIButton *coin65Btn = [UIButton new];
    [coin65Btn setImage:SYImageNamed(@"bCoin_65") forState:UIControlStateNormal];
    _coin65Btn = coin65Btn;
    [scrollView addSubview:coin65Btn];
    
    UIView *coinRightsView = [UIView new];
    coinRightsView.backgroundColor = [UIColor whiteColor];
    _coinRightsView = coinRightsView;
    [scrollView addSubview:coinRightsView];
    
    UILabel *coinRightsLabel = [UILabel new];
    coinRightsLabel.textAlignment = NSTextAlignmentLeft;
    coinRightsLabel.font = SYRegularFont(14);
    coinRightsLabel.textColor = SYColor(51, 51, 51);
    coinRightsLabel.text = @"聊豆特权";
    _coinRightsLabel = coinRightsLabel;
    [coinRightsView addSubview:coinRightsLabel];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *rightImageView = [UIImageView new];
        rightImageView.image = SYImageNamed(_rightImagesArray[i]);
        [coinRightsView addSubview:rightImageView];
        UILabel *rightLabel = [UILabel new];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.font = SYRegularFont(10);
        rightLabel.textColor = SYColor(51, 51, 51);
        rightLabel.text = _rightTextsArray[i];
        [coinRightsView addSubview:rightLabel];
        
        CGFloat margin = (SY_SCREEN_WIDTH - 57 * 3) / 4;
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(57);
            make.top.equalTo(self.coinRightsLabel.mas_bottom).offset(15);
            make.left.equalTo(self.coinRightsView).offset(margin + i * (margin + 57));
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rightImageView);
            make.height.offset(20);
            make.top.equalTo(rightImageView.mas_bottom).offset(15);
        }];
    }
    
    UIView *coinPriceView = [UIView new];
    coinPriceView.backgroundColor = [UIColor whiteColor];
    _coinPriceView = coinPriceView;
    [scrollView addSubview:coinPriceView];
    
    UILabel *coinPriceLabel = [UILabel new];
    coinPriceLabel.textAlignment = NSTextAlignmentLeft;
    coinPriceLabel.textColor = SYColor(51, 51, 51);
    coinPriceLabel.font = SYRegularFont(13);
    coinPriceLabel.text = @"聊豆价格";
    _coinPriceLabel = coinPriceLabel;
    [coinPriceView addSubview:coinPriceLabel];
    
    UILabel *coinPriceDetailLabel = [UILabel new];
    coinPriceDetailLabel.textAlignment = NSTextAlignmentLeft;
    coinPriceDetailLabel.textColor = SYColor(51, 51, 51);
    coinPriceDetailLabel.font = SYRegularFont(12);
    coinPriceDetailLabel.text = @"1.发一条消息消耗1聊豆。\n2.查看一次手机号消耗1聊豆。";
    coinPriceDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    coinPriceDetailLabel.numberOfLines = 0;
    _coinPriceDetailLabel = coinPriceDetailLabel;
    [coinPriceView addSubview:coinPriceDetailLabel];
    
    UIView *coinActivityView = [UIView new];
    coinActivityView.backgroundColor = [UIColor whiteColor];
    _coinActivityView = coinActivityView;
    [scrollView addSubview:coinActivityView];
    
    UILabel *coinActivityLabel = [UILabel new];
    coinActivityLabel.textAlignment = NSTextAlignmentLeft;
    coinActivityLabel.textColor = SYColor(51, 51, 51);
    coinActivityLabel.font = SYRegularFont(13);
    coinActivityLabel.text = @"聊豆活动";
    _coinActivityLabel = coinActivityLabel;
    [coinActivityView addSubview:coinActivityLabel];
    
    UILabel *coinActivityDetailLabel = [UILabel new];
    coinActivityDetailLabel.textAlignment = NSTextAlignmentLeft;
    coinActivityDetailLabel.textColor = SYColor(51, 51, 51);
    coinActivityDetailLabel.font = SYRegularFont(12);
    coinActivityDetailLabel.text = @"1.充值话费目前仅限中国移动，中国联通及中国电信。\n2.话费领取：请于充值后联系红娘客服获取话费。";
    coinActivityDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    coinActivityDetailLabel.numberOfLines = 0;
    _coinActivityDetailLabel = coinActivityDetailLabel;
    [coinActivityView addSubview:coinActivityDetailLabel];
}

- (void)_makeSubViewsConstraints {
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_advImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.scrollView);
        make.width.offset(SY_SCREEN_WIDTH);
        make.height.offset(140);
    }];
    [_chatCoinsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.advImageView);
        make.height.offset(30);
        make.top.equalTo(self.advImageView.mas_bottom);
    }];
    [_chatCoinsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chatCoinsView);
        make.left.equalTo(self.chatCoinsView).offset(15);
        make.height.offset(20);
    }];
    [_chatCoinsAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chatCoinsLabel.mas_right).offset(15);
        make.height.centerY.equalTo(self.chatCoinsLabel);
    }];
    [_buyersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(85);
        make.left.width.equalTo(self.chatCoinsView);
        make.top.equalTo(self.chatCoinsView.mas_bottom).offset(15);
    }];
    [_buyersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyersView).offset(15);
        make.height.offset(20);
        make.left.equalTo(self.chatCoinsLabel);
    }];
    [_coin100Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyersView.mas_bottom).offset(15);
        make.left.width.equalTo(self.buyersView);
        make.height.offset(60);
    }];
    [_coin65Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coin100Btn.mas_bottom).offset(15);
        make.left.width.equalTo(self.buyersView);
        make.height.offset(60);
    }];
    [_coinRightsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.coin65Btn);
        make.top.equalTo(self.coin65Btn.mas_bottom).offset(15);
        make.height.offset(157);
    }];
    [_coinRightsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.coinRightsView).offset(15);
        make.top.equalTo(self.coinRightsView).offset(15);
    }];
    [_coinPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(105);
        make.left.width.equalTo(self.coinRightsView);
        make.top.equalTo(self.coinRightsView.mas_bottom).offset(15);
    }];
    [_coinPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinPriceView).offset(15);
        make.top.equalTo(self.coinPriceView).offset(15);
        make.height.offset(15);
    }];
    [_coinPriceDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.left.equalTo(self.coinPriceLabel);
        make.top.equalTo(self.coinPriceLabel.mas_bottom).offset(15);
    }];
    [_coinActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(105);
        make.left.width.equalTo(self.coinRightsView);
        make.top.equalTo(self.coinPriceView.mas_bottom).offset(15);
    }];
    [_coinActivityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinActivityView).offset(15);
        make.top.equalTo(self.coinActivityView).offset(15);
        make.height.offset(15);
    }];
    [_coinActivityDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.left.equalTo(self.coinActivityLabel);
        make.top.equalTo(self.coinActivityLabel.mas_bottom).offset(15);
    }];
}

@end
