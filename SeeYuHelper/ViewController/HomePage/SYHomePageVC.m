//
//  SYHomePageVC.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYHomePageVC.h"
#import "SYNavigationController.h"
#import "SYMainFrameVC.h"
#import "SYSingleChattingVC.h"
#import "SYProfileVC.h"

@interface SYHomePageVC ()
/// viewModel
@property (nonatomic, readonly, strong) SYHomePageVM *viewModel;
@end

@implementation SYHomePageVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化所有的子控制器
    [self _setupAllChildViewController];
    /// set delegate
    self.tabBarController.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBadgeValue) name:@"refreshBadgeValue" object:nil];
}

#pragma mark - 初始化所有的子视图控制器
- (void)_setupAllChildViewController {
    NSArray *titlesArray = @[@"首页", @"客服", @"我的"];
    NSArray *imageNamesArray = @[@"tab_home_normal",@"tab_cs_normal",@"tab_self_normal"];
    NSArray *selectedImageNamesArray = @[@"tab_home_pressed",@"tab_cs_pressed",@"tab_self_pressed"];
    
    /// 首页
    UINavigationController *mainFrameNavigationController = ({
        SYMainFrameVC *mainFrameViewController = [[SYMainFrameVC alloc] initWithViewModel:self.viewModel.mainFrameViewModel];
        
        SYTabBarItemTagType tagType = SYTabBarItemTagTypeMainFrame;
        /// 配置
        [self _configViewController:mainFrameViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];
        /// 添加到导航栏的栈底控制器
        [[SYNavigationController alloc] initWithRootViewController:mainFrameViewController];
    });
    
    /// 客服
    UINavigationController *customerServiceNavigationController = ({
        SYSingleChattingVC *contactsViewController = [SYSingleChattingVC new];
        
        SYTabBarItemTagType tagType = SYTabBarItemTagTypeCustomerService;
        /// 配置
        [self _configViewController:contactsViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];
        
        [[SYNavigationController alloc] initWithRootViewController:contactsViewController];
    });
    
    /// 我的
    UINavigationController *profileNavigationController = ({
        SYProfileVC *profileViewController = [[SYProfileVC alloc] initWithViewModel:self.viewModel.profileViewModel];

        SYTabBarItemTagType tagType = SYTabBarItemTagTypeProfile;
        /// 配置
        [self _configViewController:profileViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];

        [[SYNavigationController alloc] initWithRootViewController:profileViewController];
    });
    
    /// 添加到tabBarController的子视图
    self.tabBarController.viewControllers = @[ mainFrameNavigationController, customerServiceNavigationController, profileNavigationController ];
    
    /// 配置栈底
    [SYSharedAppDelegate.navigationControllerStack pushNavigationController:mainFrameNavigationController];
}

#pragma mark - 配置ViewController
- (void)_configViewController:(UIViewController *)viewController imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title itemTag:(SYTabBarItemTagType)tagType {
    
    UIImage *image = SYImageNamed(imageName);
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.tag = tagType;
    
    UIImage *selectedImage = SYImageNamed(selectedImageName);
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
    viewController.tabBarItem.title = title;
    
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName:SYColorFromHexString(@"#929292"),
                                 NSFontAttributeName:SYRegularFont_10};
    NSDictionary *selectedAttr = @{NSForegroundColorAttributeName:SYColorFromHexString(@"#9F69EB"),
                                   NSFontAttributeName:SYRegularFont_10};
    [viewController.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    
    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 0)];
    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}


#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    YYCache *cache = [YYCache cacheWithName:@"SeeYuHelper"];
    SYTabBarItemTagType tagType = viewController.tabBarItem.tag;
    if (tagType == SYTabBarItemTagTypeCustomerService) {
        id from = [cache objectForKey:@"customeServiceFrom"];
        int tag = (int)from;
        if (tag == SYTabBarItemTagTypeMainFrame) {
            [SYNotificationCenter postNotificationName:@"enterCSViewFromMain" object:nil];
        } else {
            [SYNotificationCenter postNotificationName:@"enterCSViewFromProfile" object:nil];
        }
        return NO;
    } else if(tagType == SYTabBarItemTagTypeMainFrame) {
        [cache setObject:@"0" forKey:@"customeServiceFrom"];
        return YES;
    } else {
        [cache setObject:@"2" forKey:@"customeServiceFrom"];
        return YES;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"viewController   %@  %zd",viewController,viewController.tabBarItem.tag);
    [SYSharedAppDelegate.navigationControllerStack popNavigationController];
    [SYSharedAppDelegate.navigationControllerStack pushNavigationController:(UINavigationController *)viewController];
}

- (void)refreshBadgeValue {
    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    UIViewController *vc = self.tabBarController.viewControllers[2];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (totalUnreadCount > 0) {
            vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",totalUnreadCount];
        } else {
            vc.tabBarItem.badgeValue = nil;
        }
    });
}

- (void)dealloc {
    SYDealloc;
    // 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshBadgeValue" object:nil];
}

@end
