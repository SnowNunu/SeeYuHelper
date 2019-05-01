//
//  SYMomentCommentToolView.m
//  WeChat
//
//  Created by senba on 2018/1/23.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "SYMomentCommentToolView.h"
//#import "SYMomentReplyItemViewModel.h"

@interface SYMomentCommentToolView () <YYTextViewDelegate>

/// topLine
@property (nonatomic, readwrite, weak) UIView *topLine;

/// bottomLine
@property (nonatomic, readwrite, weak) UIView *bottomLine;



/** 记录之前编辑框的高度 */
@property (nonatomic, readwrite, assign) CGFloat previousTextViewContentHeight;

/// toHeight (随着文字的输入，SYMomentCommentToolView 将要到达的高度)
@property (nonatomic, readwrite, assign) CGFloat toHeight;

//@property (nonatomic, readwrite, strong) SYMomentReplyItemViewModel *viewModel;

@end


@implementation SYMomentCommentToolView
#pragma mark - Public Method
- (BOOL)sy_canBecomeFirstResponder{ return [self.textView canBecomeFirstResponder]; }
- (BOOL)sy_becomeFirstResponder{ return [self.textView becomeFirstResponder]; }
- (BOOL)sy_canResignFirstResponder { return [self.textView canResignFirstResponder]; }
- (BOOL)sy_resignFirstResponder { return [self.textView resignFirstResponder]; }

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化
        [self _setup];
        // 创建自控制器
        [self _setupSubViews];
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

///// 绑定数据模型
//- (void)bindViewModel:(SYMomentReplyItemViewModel *)viewModel{
//    self.viewModel = viewModel;
//
//    /// 修改textView的placeholder
//    self.textView.placeholderText = self.viewModel.isReply?[NSString stringWithFormat:@"回复%@:",self.viewModel.toUser.screenName]:@"评论";
//}

#pragma mark - 初始化
- (void)_setup {
    self.backgroundColor = SYColorFromHexString(@"#F1F1F1");
    self.previousTextViewContentHeight = SYMomentCommentToolViewMinHeight;
}

#pragma mark - 初始化子空间
- (void)_setupSubViews {
    /// textView 以及 表情按钮 和 分割线
    YYTextView *textView = [[YYTextView alloc] init];
    textView.backgroundColor = SYColorFromHexString(@"#FCFCFC");
    textView.font = SYRegularFont_16;
    textView.textAlignment = NSTextAlignmentLeft;
    UIEdgeInsets insets = UIEdgeInsetsMake(9, 9, 6, 9);
    textView.textContainerInset = insets;
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.layer.cornerRadius = 6;
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = SYGlobalBottomLineColor.CGColor;
    textView.layer.borderWidth = .5;
    textView.placeholderText = @"聊点什么吧...";
    textView.placeholderTextColor = SYColorFromHexString(@"#AAAAAA");
    textView.delegate = self;
    self.textView = textView;
    [self addSubview:textView];
    
    /// 发布按钮
    UIButton *releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
    [releaseBtn setTitleColor:SYColor(159,105,235) forState:UIControlStateNormal];
    self.releaseBtn = releaseBtn;
    [self addSubview:releaseBtn];
    
    /// 上下两条分割线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = SYGlobalBottomLineColor;
    [self addSubview:topLine];
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = SYGlobalBottomLineColor;
    [self addSubview:bottomLine];
    self.topLine = topLine;
    self.bottomLine = bottomLine;
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    /// 布局表情按钮
    [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.right.equalTo(self).with.offset(-13);
        make.width.offset(52);
        make.height.offset(60);
        make.height.mas_equalTo(30);
    }];
    /// 布局topLine
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self);
        make.height.mas_equalTo(SYGlobalBottomLineHeight);
    }];
    /// 布局bottomLine
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self);
        make.height.mas_equalTo(SYGlobalBottomLineHeight);
    }];
    /// 布局textView
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(16);
        make.top.equalTo(self).with.offset(10);
        make.bottom.equalTo(self).with.offset(-10);
        make.right.equalTo(self.releaseBtn.mas_left).with.offset(-13);
    }];
}


#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    // 改变高度
    [self _commentViewWillChangeHeight:[self _getTextViewHeight:textView]];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) { //判断输入的字是否是回车，即按下return
//        //在这里做你响应return键的代码 （发送）
//        /// 传递文本内容
////        self.viewModel.text = textView.text;
//        /// 传递数据
////        [self.viewModel.commentCommand execute:self.viewModel];
//        /// 轻空TextView
//        textView.text = nil;
//        /// 键盘掉下
//        [textView resignFirstResponder];
//        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
//    }
    return YES;
}

#pragma mark - 辅助方法
- (void)_commentViewWillChangeHeight:(CGFloat)toHeight {
    
    // 需要加上 SYMomentCommentToolViewWithNoTextViewHeight才是commentViewHeight
    toHeight = toHeight + SYMomentCommentToolViewWithNoTextViewHeight;
    /// 是否小于最小高度
    if (toHeight < SYMomentCommentToolViewMinHeight || self.textView.attributedText.length == 0){
        toHeight = SYMomentCommentToolViewMinHeight;
    }
    /// 是否大于最大高度
    if (toHeight > SYMomentCommentToolViewMaxHeight) { toHeight = SYMomentCommentToolViewMaxHeight ;}
    // 高度是之前的高度  跳过
    if (toHeight == self.previousTextViewContentHeight) return;
    /// 记录上一次的高度
    self.previousTextViewContentHeight = toHeight;
    /// 记录toheight 
    self.toHeight = toHeight;
}


/** 获取编辑框的高度 */
- (CGFloat)_getTextViewHeight:(YYTextView *)textView {
    return textView.textLayout.textBoundingSize.height;
}

@end
