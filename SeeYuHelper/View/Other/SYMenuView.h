//
//  SYMenuView.h
//  SYMenuView
//
//  Created by shaoting kan on 2019/1/8.
//  Copyright © 2019年 Yuqian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 多列表切换菜单栏
 */
@class SYMenuView;

@protocol SYMenuViewDelegate <NSObject>

@optional

- (void)menuClickedButtonAtIndex:(NSInteger)aIndex;
- (void)menuClickedButtonAtIndex:(NSInteger)aIndex menuView:(UIView *)mView;

@end

@interface SYMenuView : UIView

@property (nonatomic, weak) id <SYMenuViewDelegate> delegate;

@property (nonatomic, strong) UIFont                     *titleFont;
@property (nonatomic, strong) UIFont                     *selectTitleFont;
@property (nonatomic, strong) UIColor                    *titleColor;
@property (nonatomic, strong) UIColor                    *selectTitleColor;
@property (nonatomic, strong) NSArray                    *imageNormalArray;
@property (nonatomic, strong) NSArray                    *imageSelectArray;
@property (nonatomic, strong) UIColor                    *separatorColor;
@property (nonatomic, strong) UIColor                    *verticalBarColor;
@property (nonatomic, assign) CGSize                     separatorSize;
@property (nonatomic, assign) float                      width;
@property (nonatomic, assign) CGFloat                    itemWidth;
@property (nonatomic, assign) NSInteger                  maxNum;

/**
 初始化菜单
 */
- (id)initWithFrame:(CGRect)frame buttonItems:(NSArray *)aItemsArray;
- (void)createMenuItems:(NSArray *)aItemsArray;

/**
 选中某个button
 */
- (void)clickButtonAtIndex:(NSInteger)aIndex;

/**
 改变第几个button为选中状态，不发送delegate
 */
- (void)changeButtonStateAtIndex:(NSInteger)aIndex;

/**
 隐藏下划线
 */
- (void)hideLineImageView;

/**
 改变按钮名称
 */
- (void)changeButtonName:(NSArray *)titleArray;


/**
 底部线条跟着滑动

 @param offset 滑动偏移量
 */
- (void)scrollSignLineImageView:(CGFloat)offset;

@end
