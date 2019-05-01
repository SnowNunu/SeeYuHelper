//
//  SYTextField.m
//  WeChat
//
//  Created by senba on 2017/10/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYTextField.h"

@implementation SYTextField

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.tintColor = SY_MAIN_TINTCOLOR;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = SY_MAIN_TINTCOLOR;
    }
    return self;
}
@end
