//
//  UIView+SYFrame.h
//  SYDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He
 *  这个分类主要用来  快速获得或者添加 控件的尺寸 ....
 */

#import <UIKit/UIKit.h>

@interface UIView (SYFrame)

/// < Shortcut for frame.origin.x.
@property (nonatomic, readwrite, assign) CGFloat sy_left;
/// < Shortcut for frame.origin.y
@property (nonatomic, readwrite, assign) CGFloat sy_top;
/// < Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, readwrite, assign) CGFloat sy_right;
/// < Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, readwrite, assign) CGFloat sy_bottom;

/// < Shortcut for frame.origin.x.
@property (nonatomic, readwrite, assign) CGFloat sy_x;
/// < Shortcut for frame.origin.y
@property (nonatomic, readwrite, assign) CGFloat sy_y;
/// < Shortcut for frame.size.width
@property (nonatomic, readwrite, assign) CGFloat sy_width;
/// < Shortcut for frame.size.height
@property (nonatomic, readwrite, assign) CGFloat sy_height;

/// < Shortcut for center.x
@property (nonatomic, readwrite, assign) CGFloat sy_centerX;
///< Shortcut for center.y
@property (nonatomic, readwrite, assign) CGFloat sy_centerY;

/// < Shortcut for frame.size.
@property (nonatomic, readwrite, assign) CGSize sy_size;
/// < Shortcut for frame.origin.
@property (nonatomic, readwrite, assign) CGPoint sy_origin;




@end
