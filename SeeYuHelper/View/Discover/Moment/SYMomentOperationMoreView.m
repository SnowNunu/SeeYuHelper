//
//  SYMomentOperationMoreView.m
//  SYDevelopExample
//
//  Created by senba on 2017/7/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYMomentOperationMoreView.h"
#import "SYMomentOperationMoreItemView.h"
//#import "SYMomentItemViewModel.h"

/// Hide Notification
static NSString * const SYMomentOperationMoreViewHideNotification = @"SYMomentOperationMoreViewHideNotification";
static NSString * const SYMomentOperationMoreViewHideUserInfoKey = @"SYMomentOperationMoreViewHideUserInfoKey";


@interface SYMomentOperationMoreView ()
/// viewModel
//@property (nonatomic, readwrite, strong) SYMomentItemViewModel *viewModel;
/// 点赞
@property (nonatomic, readwrite, weak) SYMomentOperationMoreItemView *attitudesBtn;
/// 评论
@property (nonatomic, readwrite, weak) SYMomentOperationMoreItemView *commentBtn;
/// 分割线
@property (nonatomic, readwrite, weak) UIImageView *divider;
/// 是否已显示
@property (nonatomic, readwrite, assign) BOOL isShow;

@end

@implementation SYMomentOperationMoreView

+ (instancetype)operationMoreView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /// 设置能交互
        self.userInteractionEnabled = YES;
        self.image = [UIImage sy_resizableImage:@"wx_albumOperateMoreViewBkg_40x39"];
        /// 当宽度为0的时候 子控件也消失
        self.clipsToBounds = YES;
        /// 高亮状态下的背景色
        /// 评论
        UIImage * cBackgroundImage = [UIImage sy_resizableImage:@"wx_albumCommentBackgroundHL_15x39"];
        /// 赞
        UIImage * aBackgroundImage = [UIImage sy_resizableImage:@"wx_albumLikeBackgroundHL_15x39"];
        /// 设置点赞按钮
        SYMomentOperationMoreItemView *attitudesBtn = [SYMomentOperationMoreItemView buttonWithType:UIButtonTypeCustom];
        [attitudesBtn setTitle:@"赞" forState:UIControlStateNormal];
        [attitudesBtn setImage:SYImageNamed(@"wx_albumLike_20x20") forState:UIControlStateNormal];
        [attitudesBtn setImage:SYImageNamed(@"wx_albumLikeHL_20x20") forState:UIControlStateHighlighted];
        [attitudesBtn setBackgroundImage:aBackgroundImage forState:UIControlStateHighlighted];
        /// 开启点击动画
        attitudesBtn.allowAnimationWhenClick = YES;
        self.attitudesBtn = attitudesBtn;
        [self addSubview:attitudesBtn];
        
        /// 设置分割线
        UIImageView *divider = [[UIImageView alloc] initWithImage:SYImageNamed(@"wx_albumCommentLine_0x24")];
        self.divider = divider;
        [self addSubview:divider];
        
        /// 设置评论按钮
        SYMomentOperationMoreItemView *commentBtn = [SYMomentOperationMoreItemView buttonWithType:UIButtonTypeCustom];
        [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [commentBtn setImage:SYImageNamed(@"wx_albumCommentSingleA_20x20") forState:UIControlStateNormal];
        [commentBtn setImage:SYImageNamed(@"wx_albumCommentSingleAHL_20x20") forState:UIControlStateHighlighted];
        [commentBtn setBackgroundImage:cBackgroundImage forState:UIControlStateHighlighted];
        self.commentBtn = commentBtn;
        [self addSubview:commentBtn];
        
        /// 事件处理
        @weakify(self);
        /// 点赞点击事件
        [[attitudesBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton *sender) {
             @strongify(self);
             !self.attitudesClickedCallback?:self.attitudesClickedCallback(self);
             [self hideAnimated:YES afterDelay:SYMommentAnimatedDuration];
             
         }];
        /// 评论点击事件
        [[commentBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton *sender) {
             @strongify(self);
             /// 这里实现判断 键盘是否已经抬起
             if (SYSharedAppDelegate.isShowKeyboard) {
                 [SYSharedAppDelegate.window endEditing:YES]; /// 关掉键盘
             }else{
                 !self.commentClickedCallback?:self.commentClickedCallback(self);
                 [self hideAnimated:YES afterDelay:0.1];
             }
         }];
        
        
        /// 添加通知
        [[SYNotificationCenter rac_addObserverForName:SYMomentOperationMoreViewHideNotification object:nil] subscribeNext:^(NSNotification * note) {
            BOOL animated = [note.userInfo[SYMomentOperationMoreViewHideUserInfoKey] boolValue];
            [self hideWithAnimated:animated];
        }];
    }
    return self;
}
#pragma mark - Show Or Hide

- (void)showWithAnimated:(BOOL)animated
{
    if (self.isShow) return;
    
    /// 隐藏之前显示的所有的MoreView
    [[self class] hideAllOperationMoreViewWithAnimated:YES];
    
    /// 置为Yes
    self.isShow = YES;
    
    if (!animated) {
        self.sy_width = SYMomentOperationMoreViewWidth;
        self.sy_x = self.sy_x-self.sy_width;
        return;
    }
    
    /// 动画
    [UIView animateWithDuration:SYMommentAnimatedDuration delay:0 usingSpringWithDamping:.7f initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.sy_width = SYMomentOperationMoreViewWidth;
        self.sy_x = self.sy_x-self.sy_width;
        /// 强制布局
      
    } completion:^(BOOL finished) {
    }];
}

- (void)hideWithAnimated:(BOOL)animated
{
    [self hideAnimated:animated afterDelay:0];
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    if (!self.isShow) return;
    
     self.isShow = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!animated) {
            // 无动画
            self.sy_x = self.sy_x + self.sy_width;
            self.sy_width = 0;
            self.isShow = NO;
            return ;
        }

        /// 动画
        [UIView animateWithDuration:SYMommentAnimatedDuration delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.sy_x = self.sy_x + self.sy_width;
            self.sy_width = 0;
            /// 强制布局
            
        } completion:^(BOOL finished) {
        }];
        
    });

}

/// 隐藏所有操作Menu
+ (void)hideAllOperationMoreViewWithAnimated:(BOOL)animated;{
    /// 发布通知
    [SYNotificationCenter postNotificationName:SYMomentOperationMoreViewHideNotification object:nil userInfo:@{SYMomentOperationMoreViewHideUserInfoKey:@(animated)}];
}


//#pragma mark - BinderData
//- (void)bindViewModel:(SYMomentItemViewModel *)viewModel{
//    self.viewModel = viewModel;
//    /// 直接设置 normal 状态下文字即可
//    [self.attitudesBtn setTitle:viewModel.moment.attitudesStatus==0?@"赞":@"取消" forState:UIControlStateNormal];
//}


- (void)setFrame:(CGRect)frame{
    /// 固定高度
    frame.size.height = SYMomentOperationMoreViewHeight;
    [super setFrame:frame];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    /// 布局赞
    CGFloat attitudesBtnW = (self.sy_width - self.divider.sy_width)*.5f;
    CGFloat attitudesBtnH = self.sy_height;
    self.attitudesBtn.sy_size = CGSizeMake(attitudesBtnW, attitudesBtnH);
    
    
    /// 布局分割线
    self.divider.sy_x = CGRectGetMaxX(self.attitudesBtn.frame);
    self.divider.sy_centerY = self.sy_height*.5f;
    
    
    /// 布局评论
    CGFloat commentBtnX = CGRectGetMaxX(self.divider.frame);
    CGFloat commentBtnW = attitudesBtnW;
    CGFloat commentBtnH = attitudesBtnH;
    self.commentBtn.frame = CGRectMake(commentBtnX, 0, commentBtnW, commentBtnH);
    
}
@end
