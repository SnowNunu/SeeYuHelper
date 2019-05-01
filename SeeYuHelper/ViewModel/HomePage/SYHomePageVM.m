//
//  SYHomePageVM.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYHomePageVM.h"

@interface SYHomePageVM ()
/// The view model of `MainFrame` interface.
@property (nonatomic, strong, readwrite) SYMainFrameVM *mainFrameViewModel;

@property (nonatomic, strong, readwrite) SYCollocationVM *collocationViewModel;

/// The view model of `contacts` interface.
@property (nonatomic, strong, readwrite) SYContactsVM *contactsViewModel;

/// The view model of `discover` interface.
@property (nonatomic, strong, readwrite) SYDiscoverVM *discoverViewModel;

/// The view model of `Profile` interface.
@property (nonatomic, strong, readwrite) SYProfileVM *profileViewModel;
@end

@implementation SYHomePageVM

- (void)initialize {
    [super initialize];
    
    self.mainFrameViewModel  = [[SYMainFrameVM alloc] initWithServices:self.services params:nil];
    
    self.collocationViewModel = [[SYCollocationVM alloc] initWithServices:self.services params:nil];
    
    self.contactsViewModel   = [[SYContactsVM alloc] initWithServices:self.services params:nil];
    
    self.discoverViewModel   = [[SYDiscoverVM alloc] initWithServices:self.services params:nil];
    
    self.profileViewModel    = [[SYProfileVM alloc] initWithServices:self.services params:nil];
}

@end
