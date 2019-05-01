//
//  SYSegmentedControlController.h
//  WeChat
//
//  Created by senba on 2017/12/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYVC.h"

@class SYSegmentedControlController;

@protocol SYSegmentedControlControllerDelegate <NSObject>

@optional

- (void)segmentedControlController:(SYSegmentedControlController *)segmentedControlController didSelectViewController:(UIViewController *)viewController;

@end

@interface SYSegmentedControlController : SYVC

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) id<SYSegmentedControlControllerDelegate> delegate;

@end

@interface UIViewController (SYSegmentedControlItem)

@property (nonatomic, copy) NSString *segmentedControlItem;

@end

