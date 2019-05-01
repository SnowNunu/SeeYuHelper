//
//  SYViewModelServicesImpl.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYViewModelServicesImpl.h"

@implementation SYViewModelServicesImpl
@synthesize client = _client;
- (instancetype)init
{
    self = [super init];
    if (self) {
         _client = [SYHTTPService sharedInstance];
    }
    return self;
}


#pragma mark - SBNavigationProtocol empty operation
- (void)pushViewModel:(SYVM *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(SYVM *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)resetRootViewModel:(SYVM *)viewModel {}

@end
