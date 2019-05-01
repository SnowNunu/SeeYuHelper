//
//  SYForumListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumListCell.h"

@implementation SYForumListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    YYLabel *titleLabel = [YYLabel new];
    titleLabel.numberOfLines = 0;   // 开启多行显示
    titleLabel.preferredMaxLayoutWidth = SY_SCREEN_WIDTH - 60;
    titleLabel.font = SYRegularFont(16);
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    UIImageView *titleImageView = [UIImageView new];
    titleImageView.layer.cornerRadius = 6.f;
    titleImageView.clipsToBounds = YES;
    _titleImageView = titleImageView;
    [self addSubview:titleImageView];
    
    YYLabel *contentLabel = [YYLabel new];
    contentLabel.numberOfLines = 2;   // 开启多行显示
    contentLabel.preferredMaxLayoutWidth = SY_SCREEN_WIDTH - 60;
    contentLabel.font = SYRegularFont(13);
    contentLabel.textColor = SYColor(153, 153, 153);
    _contentLabel = contentLabel;
    [self addSubview:contentLabel];
    
    UIImageView *commentImageView = [UIImageView new];
    commentImageView.image = SYImageNamed(@"news_icon_comment");
    _commentImageView = commentImageView;
    [self addSubview:commentImageView];
    
    UILabel *commentsNumLabel = [UILabel new];
    commentsNumLabel.textColor = SYColor(153, 153, 153);
    commentsNumLabel.font = SYRegularFont(15);
    _commentsNumLabel = commentsNumLabel;
    [self addSubview:commentsNumLabel];
    
    UILabel *toAnswerLabel = [UILabel new];
    toAnswerLabel.textColor = SYColor(159, 105, 235);
    toAnswerLabel.font = SYRegularFont(15);
    toAnswerLabel.text = @"去回答";
    _toAnswerLabel = toAnswerLabel;
    [self addSubview:toAnswerLabel];
}

- (void)_makeSubViewsConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self).offset(15);
        make.height.offset(20);
    }];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.width.equalTo(self.titleLabel);
        make.height.offset(0);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImageView.mas_bottom).offset(15);
        make.left.width.equalTo(self.titleLabel);
    }];
    [self.commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
        make.width.height.offset(13);
        make.bottom.equalTo(self).offset(-15);
        make.left.equalTo(self.contentLabel);
    }];
    [self.commentsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentImageView.mas_right).offset(6);
        make.width.offset(60);
        make.height.centerY.equalTo(self.commentImageView);
    }];
    [self.toAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentLabel).offset(6);
        make.width.offset(60);
        make.height.centerY.equalTo(self.commentImageView);
    }];
}

- (void)setTitleImageViewByUrl:(NSString *)url {
    [self.titleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.height.equalTo(self.titleImageView.mas_width).multipliedBy(0.476);
    }];
    [self.titleImageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
}

@end
