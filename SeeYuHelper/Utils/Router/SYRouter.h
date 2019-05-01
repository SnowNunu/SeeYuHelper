//
//  SYRouter.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  ViewModel -- ViewController

#import <Foundation/Foundation.h>
#import "SYVC.h"

@interface SYRouter : NSObject
/// Retrieves the shared router instance.
///
/// Returns the shared router instance.
+ (instancetype)sharedInstance;

/// Retrieves the view corresponding to the given view model.
///
/// viewModel - The view model
///
/// Returns the view corresponding to the given view model.
- (SYVC *)viewControllerForViewModel:(SYVM *)viewModel;
@end
