//
//  SYWithdrawalRulesVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYWithdrawalRulesVC.h"

@interface SYWithdrawalRulesVC ()

@end

@implementation SYWithdrawalRulesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    
    NSString *rulesText = @"1.提现最低额度分为100元，每次提现时满足提现额度时即可申请提现。\n\n2.提现一般3~5个工作日内到账（您理解并同意如遇提现高峰，提现到账时间会延长）。\n\n3.您理解并同意我们应用先进的人工智能分析您的行为，如发现造假等违规操作，我们有权阻止您使用（填写邀请码、领取金币、提现、奖励）以及取消您获得的奖励。\n\n4.为保证用户顺利提现，提现需用户按照提现页面规范操作。如用户未按提现要求操作或不符合第三方支付平台的要求等原因导致不能收款（如未做实名认证或提现前与平台账号解绑等），所获得的红包将无法提现，本平台无需承担任何责任。\n\n5.如果您连续30日未登录本APP，那么此前发放的奖励将过期，逾期未提现则视为用户自愿放弃提现的权利，账户金额将被清零。";
    
    CGSize size = [rulesText sy_sizeWithFont:SYRegularFont(13) limitWidth:SY_SCREEN_WIDTH - 30.f];
    
    UILabel *rulesLabel = [UILabel new];
    rulesLabel.textAlignment = NSTextAlignmentLeft;
    rulesLabel.textColor = SYColor(51, 51, 51);
    rulesLabel.font = SYRegularFont(13);
    rulesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    rulesLabel.text = rulesText;
    rulesLabel.numberOfLines = 0;
    [scrollView addSubview:rulesLabel];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [rulesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(30);
        make.left.equalTo(scrollView).offset(15);
        make.width.offset(size.width);
        make.height.offset(size.height);
    }];
    scrollView.contentSize = CGSizeMake(SY_SCREEN_WIDTH, size.height + 60);
    
}


@end
