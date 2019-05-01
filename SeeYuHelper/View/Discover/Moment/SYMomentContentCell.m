//
//  SYMomentContentCell.m
//  SYDevelopExample
//
//  Created by senba on 2017/7/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYMomentContentCell.h"

@interface SYMomentContentCell ()
/// 正文
@property (nonatomic, readwrite, weak) YYLabel *contentLable;

//@property (nonatomic , readwrite , strong) SYMomentContentItemViewModel *viewModel;
@end

@implementation SYMomentContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MomentContentCell";
    SYMomentContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
    }
    return self;
}

//#pragma mark - BindViewModel 子类重写
//- (void)bindViewModel:(SYMomentContentItemViewModel *)viewModel{
//    self.viewModel = viewModel;
//    /// 文本
//    self.contentLable.textLayout = viewModel.contentLableLayout;
//    self.contentLable.frame = viewModel.contentLableFrame;
//
//    self.selectionStyle = (viewModel.type == SYMomentContentTypeComment)?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone;
//    self.divider.hidden = viewModel.type == SYMomentContentTypeComment;
//}

#pragma mark - 初始化
- (void)_setup
{
    // 设置颜色
    self.contentView.backgroundColor = SYMomentCommentViewBackgroundColor;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews {
    /// 点击选中的颜色
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = SYMomentCommentViewSelectedBackgroundColor;
    self.selectedBackgroundView = selectedView;

    /// 正文
    YYLabel *contentLable = [[YYLabel alloc] init];
    contentLable.backgroundColor = self.contentView.backgroundColor;
    /// 垂直方向顶部对齐
    contentLable.textVerticalAlignment = YYTextVerticalAlignmentTop;
    /// 异步渲染和布局
    contentLable.displaysAsynchronously = NO;
    /// 利用textLayout来设置text、font、textColor...
    contentLable.ignoreCommonProperties = YES;
    contentLable.fadeOnAsynchronouslyDisplay = NO;
    contentLable.fadeOnHighlight = NO;
    contentLable.preferredMaxLayoutWidth = SYMomentCommentViewWidth()-2*SYMomentCommentViewContentLeftOrRightInset;
    [self.contentView addSubview:contentLable];
    self.contentLable = contentLable;
    
    /// 分割线 
    UIImageView *divider = [[UIImageView alloc] initWithImage:SYImageNamed(@"wx_albumCommentHorizontalLine_33x1")];
    divider.backgroundColor = WXGlobalBottomLineColor;
    self.divider = divider;
    [self.contentView addSubview:divider];
    
    
    /// 事件处理
    @weakify(self);
    contentLable.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        if (range.location >= text.length) return;
        YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:range.location];
        NSDictionary *userInfo = highlight.userInfo;
        if (userInfo.count == 0) return;
        /// 回调数据
//        [self.viewModel.attributedTapCommand execute:userInfo];
        
    };
    
    
    contentLable.highlightLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"高亮长按label事件");
    };
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /// 这里的点击事件 由自己处理
    /// 先记录
    BOOL showKeyboard = SYSharedAppDelegate.isShowKeyboard;
    /// 然后设置
    SYSharedAppDelegate.showKeyboard = NO;
    [super touchesBegan:touches withEvent:event];
    SYSharedAppDelegate.showKeyboard = showKeyboard;
}

#pragma mark - Override
/// PS:重写cell的尺寸 这是评论View关键
- (void)setFrame:(CGRect)frame{
    frame.origin.x = SYMomentContentLeftOrRightInset+SYMomentAvatarWH+SYMomentContentInnerMargin;
    frame.size.width = SYMomentCommentViewWidth();
    [super setFrame:frame];
}

#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    self.divider.frame =CGRectMake(0, self.sy_height-WXGlobalBottomLineHeight, self.sy_width, WXGlobalBottomLineHeight);
}



@end
