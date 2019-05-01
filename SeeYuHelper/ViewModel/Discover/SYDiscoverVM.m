//
//  SYDiscoverVM.m
//  WeChat
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYDiscoverVM.h"
#import "SYWebVM.h"
#import "SYMomentVM.h"

@implementation SYDiscoverVM

- (void)initialize {
    [super initialize];
    self.title = @"动态";
    
    self.momentVM = [[SYMomentVM alloc] initWithServices:self.services params:nil];
    
    self.privacyVM = [[SYPrivacyVM alloc]initWithServices:self.services params:nil];
    
    self.forumVM = [[SYForumVM alloc] initWithServices:self.services params:nil];
    
    self.webVM = [[SYWebVM alloc] initWithServices:self.services params:nil];
}
@end
