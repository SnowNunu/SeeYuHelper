//
//  SYTabBar.m
//  WeChat
//
//  Created by senba on 2017/9/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYTabBar.h"
@interface SYTabBar ()
/// divider
@property (nonatomic, readwrite, weak) UIView *divider ;
@end
@implementation SYTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /// 去掉tabBar的分割线,以及背景图片
        [self setShadowImage:[UIImage new]];
        [self setBackgroundImage:[UIImage sy_resizableImage:@"tabbarBkg_5x49"]];
        
        /// 添加细线,
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = SYColor(167.0f, 167.0f, 170.0f);
        [self addSubview:divider];
        self.divider = divider;
    }
    return self;
}


#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self bringSubviewToFront:self.divider];
    self.divider.sy_height = SYGlobalBottomLineHeight;
    self.divider.sy_width = SY_SCREEN_WIDTH;
}
@end
