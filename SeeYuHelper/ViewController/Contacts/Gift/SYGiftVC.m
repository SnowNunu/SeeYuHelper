//
//  SYGiftVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/20.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGiftVC.h"
#import "SYDiamondsVC.h"
#import "SYDiamondsVM.h"
#import "SYNavigationController.h"

@interface SYGiftVC ()

@property (nonatomic, strong) SYGiftModel *giftModel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *diamondsLabel;

@property (nonatomic, strong) UIButton *rechargeBtn;

@property (nonatomic, strong) UIButton *sendGiftBtn;

@property (nonatomic, strong) NSMutableArray *giftIdArray;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *priceArray;

@property (nonatomic, strong) NSMutableArray *labelArray;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation SYGiftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadGiftListCache];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        if (user != nil) {
            self.diamondsLabel.text = [NSString stringWithFormat:@"我的钻石：%d",user.userDiamond];
        }
    }];
    [[self.rechargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        SYDiamondsVM *diamondsVM = [[SYDiamondsVM alloc] initWithServices:SYSharedAppDelegate.services params:nil];
        SYDiamondsVC *diamondsVC = [[SYDiamondsVC alloc] initWithViewModel:diamondsVM];
        [self.navigationController pushViewController:diamondsVC animated:YES];
    }];
    [[self.sendGiftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.selectIndex == 0) {
            [MBProgressHUD sy_showTips:@"请选择一个礼物" addedToView:self.view];
        } else {
            int leftDiamonds = self.giftModel.Diamonds;
            int price = [self.priceArray[self.selectIndex - 999] intValue];
            if (leftDiamonds > price) {
                NSDictionary *parmas = @{@"userId":self.viewModel.services.client.currentUser.userId,@"receiveUserId":self.viewModel.friendId,@"giftId":self.giftIdArray[self.selectIndex - 999],@"giftNumber":@"1"};
                [self.viewModel.sendGiftCommand execute:parmas];
            } else {
                [MBProgressHUD sy_showTips:@"剩余钻石数量不足，请先进行充值" addedToView:self.view];
            }
        }
    }];
    [self.viewModel.sendGiftCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        self.viewModel.user = user;
        [self.viewModel.services.client saveUser:user];
        [MBProgressHUD sy_showTips:@"礼物赠送成功" addedToView:self.view];
    }];
    [self.viewModel.sendGiftCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error addedToView:self.view];
    }];
}

- (void)_setupSubViews {
    self.view.backgroundColor = SYColorAlpha(255, 255, 255, 0.2);
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SYSharedAppDelegate dismissVC:self.navigationController];
        });
    }];
    [self.view addGestureRecognizer:tap];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 15.f;
    bgView.layer.masksToBounds = YES;
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    UIButton *sendGiftBtn = [UIButton new];
    sendGiftBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    [sendGiftBtn setTitle:@"赠送" forState:UIControlStateNormal];
    [sendGiftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendGiftBtn.titleLabel.font = SYRegularFont(17);
    _sendGiftBtn = sendGiftBtn;
    [bgView addSubview:sendGiftBtn];
    
    CGFloat btnWidth = (SY_SCREEN_WIDTH - 15 * 7) / 4;
    CGFloat btnHeight = 1.45 * btnWidth;
    for (int i = 0; i < _labelArray.count; i++) {
        UIButton *giftBtn = [UIButton new];
        [giftBtn setImage:SYImageNamed(@"message_border") forState:UIControlStateSelected];
        giftBtn.tag = i + 999;
        [bgView addSubview:giftBtn];
        [[giftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self selectGift:giftBtn.tag];
        }];
        
        UIImageView *imageView = [UIImageView new];
        [imageView yy_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholder:SYImageNamed(@"message_icon_shoes_gift") options:SYWebImageOptionAutomatic completion:NULL];
        [giftBtn addSubview:imageView];
        
        UILabel *priceLabel = [UILabel new];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = SYColorFromHexString(@"#9F69EB");
        priceLabel.font = SYRegularFont(13);
        priceLabel.text = [NSString stringWithFormat:@"%@钻石",_priceArray[i]];
        [giftBtn addSubview:priceLabel];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = SYColorFromHexString(@"#999999");
        titleLabel.font = SYRegularFont(12);
        titleLabel.text = _labelArray[i];
        [giftBtn addSubview:titleLabel];
        
        [giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(btnWidth);
            make.height.offset(btnHeight);
            make.left.equalTo(self.bgView).offset(15 + i % 4 *(btnWidth + 15));
            make.bottom.equalTo(self.sendGiftBtn.mas_top).offset(-(20 + ((self.giftIdArray.count - 1) / 4 - i / 4) * (btnHeight + 20)));
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(giftBtn).offset(0.125 * btnHeight);
            make.centerX.equalTo(giftBtn);
            make.width.height.offset(btnWidth * 0.58);
        }];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).offset(5);
            make.height.offset(12);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(priceLabel.mas_bottom).offset(5);
            make.height.offset(12);
        }];
    }
    
    UILabel *diamondsLabel = [UILabel new];
    diamondsLabel.textAlignment = NSTextAlignmentLeft;
    diamondsLabel.textColor = SYColorFromHexString(@"#9F69EB");
    diamondsLabel.font =SYRegularFont(16);
    diamondsLabel.text = [NSString stringWithFormat:@"我的钻石：%d",self.viewModel.user.userDiamond];
    _diamondsLabel = diamondsLabel;
    [bgView addSubview:diamondsLabel];
    
    UIButton *rechargeBtn = [UIButton new];
    rechargeBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = SYRegularFont(16);
    rechargeBtn.layer.cornerRadius = 12.5f;
    rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn = rechargeBtn;
    [bgView addSubview:rechargeBtn];
}

- (void)_makeSubViewsConstraints {
    CGFloat btnWidth = (SY_SCREEN_WIDTH - 15 * 7) / 4;
    CGFloat btnHeight = 1.45 * btnWidth;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.rechargeBtn.mas_top).offset(-10);
    }];
    [_diamondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rechargeBtn);
        make.left.equalTo(self.bgView).offset(15);
        make.height.offset(20);
    }];
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15);
        make.width.offset(60);
        make.height.offset(25);
        make.bottom.equalTo(self.sendGiftBtn.mas_top).offset(-(btnHeight * 2 + 20 * 2 + 10));
    }];
    [_sendGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.left.equalTo(self.bgView);
        make.height.offset(35);
    }];
}

// 选择礼物
- (void)selectGift:(NSInteger)tag {
    self.selectIndex = tag;
    for (int i = 0; i < 8; i++) {
        UIButton *btn = [self.view viewWithTag:999 + i];
        if (tag == 999 + i) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

// 读取事先加载好的缓存信息
- (void)loadGiftListCache {
    YYCache *cache = [YYCache cacheWithName:@"seeyu"];
    if ([cache containsObjectForKey:@"giftModel"]) {
        // 有缓存数据优先读取缓存数据
        id dataValue = [cache objectForKey:@"giftModel"];
        _giftModel = (SYGiftModel*)dataValue;
        NSArray *giftArray = _giftModel.gifts;
        _giftIdArray = [NSMutableArray new];
        _imageArray = [NSMutableArray new];
        _priceArray = [NSMutableArray new];
        _labelArray = [NSMutableArray new];
        for (NSDictionary *dict in giftArray) {
            [_giftIdArray addObject:dict[@"giftId"]];
            [_imageArray addObject:dict[@"giftImg"]];
            [_priceArray addObject:dict[@"giftPrice"]];
            [_labelArray addObject:dict[@"giftName"]];
        }
    }
}

@end
