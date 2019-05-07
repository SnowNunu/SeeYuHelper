//
//  SYRouter.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYRouter.h"


@interface SYRouter ()

/// viewModel到viewController的映射
@property (nonatomic, copy) NSDictionary *viewModelViewMappings;

@end

@implementation SYRouter

static SYRouter *sharedInstance_ = nil;

+ (id)allocWithZone:(struct _NSZone *)zone
{ 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [super allocWithZone:zone];
    });
    return sharedInstance_;
}

- (id)copyWithZone:(NSZone *)zone
{
    return sharedInstance_;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[self alloc] init];
    });
    return sharedInstance_;
}

- (SYVC *)viewControllerForViewModel:(SYVM *)viewModel {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    
//    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[SYVC class]]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}


/// 这里是viewModel -> ViewController的映射
/// If You Use Push 、 Present 、 ResetRootViewController ,You Must Config This Dict
- (NSDictionary *)viewModelViewMappings {
    return @{@"SYLoginVM":@"SYLoginVC",
             @"SYInfoSupplementVM":@"SYInfoSupplementVC",
             @"SYNicknameModifyVM":@"SYNicknameModifyVC",
             @"SYSignatureVM":@"SYSignatureVC",
             @"SYHobbyVM":@"SYHobbyVC",
             @"SYCoverInfoEditVM":@"SYCoverInfoEditVC",
             @"SYVideoInfoEditVM":@"SYVideoInfoEditVC",
             @"SYHomePageVM":@"SYHomePageVC",
             @"SYBaseInfoEditVM":@"SYBaseInfoEditVC",
             @"SYAccountInfoEditVM":@"SYAccountInfoEditVC",
             @"SYPasswordModifyVM":@"SYPasswordModifyVC",
             @"SYSettingVM":@"SYSettingVC",
             @"SYAboutVM":@"SYAboutVC",
             @"SYStatisticsVM":@"SYStatisticsVC",
             @"SYFocusListVM":@"SYFocusListVC",
             @"SYPresentListVM":@"SYPresentListVC",
             @"SYLiveStatisticsVM":@"SYLiveStatisticsVC",
             @"SYLiveDetailsVM":@"SYLiveDetailsVC",
             @"SYMoneyManageVM":@"SYMoneyManageVC",
             @"SYWithdrawalVM":@"SYWithdrawalVC",
             @"SYAlipayWithdrawalVM":@"SYAlipayWithdrawalVC",
             @"SYUnionWithdrawalVM":@"SYUnionWithdrawalVC",
             @"SYAlipayConfirmVM":@"SYAlipayConfirmVC",
             @"SYUnionConfirmVM":@"SYUnionConfirmVC",
             @"SYWithdrawalRulesVM":@"SYWithdrawalRulesVC",
             @"SYPaymentsVM":@"SYPaymentsVC",
             @"SYPaymentsDetailVM":@"SYPaymentsDetailVC",
             @"SYUserDetailVM":@"SYUserDetailVC"
             };
}

@end
