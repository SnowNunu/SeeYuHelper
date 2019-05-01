//
//  SYImageView.m
//  WeChat
//
//  Created by senba on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYImageView.h"

@implementation SYImageView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
