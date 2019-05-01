//
//  SYSignatureView.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSignatureView.h"

@implementation SYSignatureView

+ (instancetype)signatureTextView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubViews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 初始化子空间
- (void)_setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.font = SYRegularFont(17);
    textView.textContainerInset = UIEdgeInsetsMake(14, 16, 22, 16 + 5);
    _textView = textView;
    [self addSubview:textView];
    
    // 分割线
    UIImageView *divider0 = [[UIImageView alloc] init];
    _divider0 = divider0;
    [self addSubview:divider0];
    
    UIImageView *divider1 = [[UIImageView alloc] init];
    _divider1 = divider1;
    [self addSubview:divider1];
    
    divider0.backgroundColor = divider1.backgroundColor = SY_MAIN_LINE_COLOR_1;
    
    /// 数字number
    UILabel *wordsLabel = [[UILabel alloc] init];
    wordsLabel.textColor = SY_MAIN_TEXT_COLOR_1;
    wordsLabel.font = SYRegularFont(12);
    wordsLabel.text = @"20";
    wordsLabel.textAlignment = NSTextAlignmentRight;
    wordsLabel.backgroundColor = self.backgroundColor;
    _wordsLabel = wordsLabel;
    [self addSubview:wordsLabel];
    
    /// 限制文字个数
    [textView sy_limitMaxLength:SYFeatureSignatureMaxWords];
    /// 监听数据变化
    @weakify(self);
    [[RACSignal merge:@[RACObserve(textView, text),textView.rac_textSignal]] subscribeNext:^(NSString * text) {
        @strongify(self);
        self.wordsLabel.text = [NSString stringWithFormat:@"%zd",SYFeatureSignatureMaxWords - text.length];
    }];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.divider0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self);
        make.height.mas_equalTo(SYGlobalBottomLineHeight);
    }];
    [self.divider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self);
        make.height.mas_equalTo(SYGlobalBottomLineHeight);
    }];
    [self.wordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-16);
        make.bottom.equalTo(self).with.offset(-9);
    }];
}

@end
