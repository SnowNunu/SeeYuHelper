//
//  SYAboutVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAboutVM.h"

@implementation SYAboutVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"关于我们";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
}
@end
