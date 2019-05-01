//
//  SYMenuView.m
//  SYMenuView
//
//  Created by shaoting kan on 2019/1/8.
//  Copyright © 2019年 Yuqian. All rights reserved.
//

#import "SYMenuView.h"

//RGB颜色值 两种参数
#define RGB(r,g,b)   [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1]
#define kMenuRed     [UIColor redColor]
#define kMenuBlack   [UIColor colorWithHexString:@"#666666"]
#define kDevideGray  [UIColor colorWithHexString:@"#dddddd"]//分割线灰色
#define kSingleWidth 50.f
#define kSingleHeight 4.f
//设备高度
#define DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//设备宽度
#define DEVICE_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface SYMenuView () {
    UIScrollView    *myScrollView;
    UIImageView     *signLineImgView;
    CGRect          rect;
}
@property (nonatomic, strong) NSMutableArray *mButtonArray;
@property (nonatomic, strong) NSMutableArray *separatorLineArray;
@end

@implementation SYMenuView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        rect = frame;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame buttonItems:(NSArray *)aItemsArray {
    
    self = [self initWithFrame:frame];
    if (self) {
        UIImageView *lineTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        lineTop.image = [UIImage imageWithColor:kDevideGray];
//        [self addSubview:lineTop];
        UIImageView *lineBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
        lineBottom.image = [UIImage imageWithColor:kDevideGray];
        [self addSubview:lineBottom];
        [self createMenuItems:aItemsArray];
    }
    return self;
}

- (void)createMenuItems:(NSArray *)aItemsArray {

    _maxNum = MAX(4, _maxNum);
    if (aItemsArray.count <= _maxNum) {
        int i = 0;
        for (NSString *title in aItemsArray) {
            
            float buttonWidth = (rect.size.width > 0 ? rect.size.width : _width) / aItemsArray.count;
            if (self.itemWidth) {
                buttonWidth = self.itemWidth;
            }
            UIButton *vButton = [self itemForMenuWithIndex:i withWidth:buttonWidth];
            [vButton setTitle:title forState:UIControlStateNormal];
            [self addSubview:vButton];
            [self.mButtonArray addObject:vButton];
            
            if (i != aItemsArray.count - 1) {
                UILabel *separatorLineLB = [self separatorLineBetweenItemWithIndex:i Width:buttonWidth];
                [self addSubview:separatorLineLB];
            }
            i++;
        }
//        signLineImgView = [self signLineWithWidth:((rect.size.width > 0 ? rect.size.width : _width) / aItemsArray.count - 30)];
        signLineImgView = [self signLineWithWidth:SCREEN_WIDTH / aItemsArray.count];
        [self addSubview:signLineImgView];
    } else {
        myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, (rect.size.width > 0 ? rect.size.width : _width), self.frame.size.height)];
        
        float buttonWidth = (rect.size.width > 0 ? rect.size.width : _width) / _maxNum;
        if (self.itemWidth) {
            buttonWidth = self.itemWidth;
        }
        myScrollView.contentSize = CGSizeMake(buttonWidth * aItemsArray.count, self.frame.size.height);
        myScrollView.showsVerticalScrollIndicator = NO;
        myScrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < aItemsArray.count; i++) {
            
            NSString *title = [aItemsArray objectAtIndex:i];
            UIButton *vButton = [self itemForMenuWithIndex:i withWidth:buttonWidth];
            [vButton setTitle:title forState:UIControlStateNormal];
            [myScrollView addSubview:vButton];
            [self.mButtonArray addObject:vButton];
            
            if (i != aItemsArray.count - 1) {
                UILabel *separatorLineLB = [self separatorLineBetweenItemWithIndex:i Width:buttonWidth];
                [myScrollView addSubview:separatorLineLB];
            }
        }
        signLineImgView = [self signLineWithWidth:(buttonWidth - 30)];
        [myScrollView addSubview:signLineImgView];
        [self addSubview:myScrollView];
    }
}

- (void)scrollSignLineImageView:(CGFloat)offset {
    
    if (!(offset <= 0 || offset >= (self.mButtonArray.count - 1) * SCREEN_WIDTH)) {
        CGFloat offsetx = offset / self.mButtonArray.count;
        signLineImgView.frame = CGRectMake(offsetx + ((SCREEN_WIDTH / self.mButtonArray.count - CGRectGetWidth(signLineImgView.frame))) / 2, self.frame.size.height - CGRectGetHeight(signLineImgView.frame), CGRectGetWidth(signLineImgView.frame), CGRectGetHeight(signLineImgView.frame));
    }
}

- (UIButton *)itemForMenuWithIndex:(NSInteger)aIndex withWidth:(CGFloat)width{
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    [item setFrame:CGRectMake(width * aIndex, 0, width, self.frame.size.height)];
    [item.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [item setTitleColor:kMenuBlack forState:UIControlStateNormal];
    if (_titleFont) {
        [item.titleLabel setFont:_titleFont];
    }
    if (_titleColor) {
        [item setTitleColor:_titleColor forState:UIControlStateNormal];
    }
    if (_imageNormalArray.count) {
        [item setImage:SYImageNamed([_imageNormalArray objectAtIndex:aIndex]) forState:UIControlStateNormal];
    }
    item.tag = aIndex;
    [item addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return item;
}

- (UILabel *)separatorLineBetweenItemWithIndex:(NSInteger)aIndex Width:(float)width {
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(width * (aIndex + 1), 10, 0.5, self.frame.size.height - 20)];
    if (_separatorSize.height > 0) {
        line.frame = CGRectMake(width * aIndex + width, (self.frame.size.height-_separatorSize.height)/2, _separatorSize.width, _separatorSize.height);
    }
    if (_verticalBarColor) {
        line.backgroundColor = _verticalBarColor;
    } else {
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    }
    [self.separatorLineArray addObject:line];
    return line;
}

- (void)setVerticalBarColor:(UIColor *)verticalBarColor{
    
    for (UILabel *line in self.separatorLineArray) {
        line.backgroundColor = verticalBarColor;
    }
}

- (UIImageView *)signLineWithWidth:(CGFloat)width {
    UIColor *lineColor = kMenuRed;
    if (_separatorColor) {
        lineColor = _separatorColor;
    }
//    UIImageView *signImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 1, width, 2)];
//    signImgView.image = [UIImage imageWithColor:lineColor];
//    return signImgView;
    UIImageView *signImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kSingleHeight, kSingleWidth, kSingleHeight)];
    signImgView.image = [UIImage imageWithColor:lineColor];
    signImgView.layer.cornerRadius = 2.f;
    signImgView.layer.masksToBounds = YES;
    return signImgView;
}

- (void)hideLineImageView {
    signLineImgView.hidden = YES;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    signLineImgView.image = [UIImage imageWithColor:separatorColor];
}

/**
 取消所有button的点击状态
 */
- (void)changeButtonsToNormalState {
    
    for (int i = 0; i < self.mButtonArray.count; i++) {
        UIButton *button = [self.mButtonArray objectAtIndex:i];
        [button setTitleColor:kMenuBlack forState:UIControlStateNormal];
        if (_titleColor) {
            [button setTitleColor:_titleColor forState:UIControlStateNormal];
        }
        if (_imageNormalArray.count) {
            [button setImage:SYImageNamed([_imageNormalArray objectAtIndex:i]) forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        }
    }
}

- (void)clickButtonAtIndex:(NSInteger)aIndex {
    UIButton *button = [self.mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:button];
}

- (void)changeButtonStateAtIndex:(NSInteger)aIndex {
    
    UIButton *vbutton = [self.mButtonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    
    [vbutton setTitleColor:kMenuRed forState:UIControlStateNormal];
    
    if (self.selectTitleColor && self.selectTitleFont ) {
        
        for (UIButton *button in self.mButtonArray) {
            if (button == vbutton) {
                [vbutton setTitleColor:self.selectTitleColor forState:UIControlStateNormal];
                [vbutton.titleLabel setFont:self.selectTitleFont];
                if (_imageNormalArray.count > 0 && _imageSelectArray.count > 0) {
                   [vbutton setImage:SYImageNamed([_imageSelectArray objectAtIndex:aIndex]) forState:UIControlStateNormal];
                }
            } else {
                [button setTitleColor:self.titleColor forState:UIControlStateNormal];
                [button.titleLabel setFont:self.titleFont];
            }
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
//        CGRect rects = self->signLineImgView.frame;
//        rects.size.width = [self widthForText:vbutton.currentTitle font:vbutton.titleLabel.font maxHeight:rects.size.height];
//        rects.size.width = SCREEN_WIDTH / self.mButtonArray.count;
//        rects.size.width = MIN(rects.size.width, vbutton.frame.size.width);
//        signLineImgView.frame = rects;
//        signLineImgView.center = CGPointMake(vbutton.center.x, self.frame.size.height - 1);
        CGRect rects = self->signLineImgView.frame;
        rects.size.width = kSingleWidth;
        
        self->signLineImgView.frame = rects;
        self->signLineImgView.center = CGPointMake(vbutton.center.x, self.frame.size.height - kSingleHeight + 2);
    }];
    
    //计算偏移量
    CGFloat offsetX = vbutton.center.x - DEVICE_WIDTH * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    //获取最大滚动范围
    CGFloat maxOffsetX = myScrollView.contentSize.width - DEVICE_WIDTH;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    //滚动标题滚动条
    [myScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (CGFloat)widthForText:(NSString *)text
                   font:(UIFont *)font
              maxHeight:(CGFloat)maxHeight
{
    
    CGRect stringRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,maxHeight)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName : font }
                                           context:nil];
    CGSize textSize = CGRectIntegral(stringRect).size;
    
    return textSize.width;
}

- (void)changeButtonName:(NSArray *)titleArray {
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [self.mButtonArray objectAtIndex:i];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
    }
}

- (void)menuButtonClicked:(UIButton *)aButton {

    [self changeButtonStateAtIndex:aButton.tag];
    
    id <SYMenuViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(menuClickedButtonAtIndex:)]) {
        [delegate menuClickedButtonAtIndex:aButton.tag];
    }
    if ([delegate respondsToSelector:@selector(menuClickedButtonAtIndex:menuView:)]) {
        [delegate menuClickedButtonAtIndex:aButton.tag menuView:self];
    }
}

#pragma mark -
#pragma mark - Properities
- (NSMutableArray *)separatorLineArray{
    if (_separatorLineArray == nil) {
        _separatorLineArray = [NSMutableArray new];
    }
    return _separatorLineArray;
}

- (NSMutableArray *)mButtonArray{
    if (_mButtonArray == nil) {
        _mButtonArray = [NSMutableArray new];
    }
    return _mButtonArray;
}

- (void)dealloc {
    [self.mButtonArray removeAllObjects];
    self.mButtonArray = nil;
    [self.separatorLineArray removeAllObjects];
    self.separatorLineArray = nil;
}

@end
