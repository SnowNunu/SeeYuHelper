//
//  SYHomePageVM.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  主界面的视图的视图模型

#import "SYTabBarViewModel.h"
#import "SYMainFrameVM.h"
#import "SYCollocationVM.h"
#import "SYContactsVM.h"
#import "SYDiscoverVM.h"
#import "SYProfileVM.h"

@interface SYHomePageVM : SYTabBarViewModel

/// The view model of `MainFrame` interface.
@property (nonatomic, strong, readonly) SYMainFrameVM *mainFrameViewModel;

/// The view model of `collocation` interface.
@property (nonatomic, strong, readonly) SYCollocationVM *collocationViewModel;

/// The view model of `contacts` interface.
@property (nonatomic, strong, readonly) SYContactsVM *contactsViewModel;

/// The view model of `discover` interface.
@property (nonatomic, strong, readonly) SYDiscoverVM *discoverViewModel;

/// The view model of `Profile` interface.
@property (nonatomic, strong, readonly) SYProfileVM *profileViewModel;

@end
