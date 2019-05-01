//
//  SYForumCommentCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumCommentCell.h"

@implementation SYForumCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    UIImageView *headPhotoView = [UIImageView new];
    headPhotoView.layer.cornerRadius = 22.5f;
    headPhotoView.layer.masksToBounds = YES;
    _headPhotoView = headPhotoView;
    [self addSubview:headPhotoView];
    
    YYLabel *aliasLabel = [YYLabel new];
    aliasLabel.font = SYRegularFont(15);
    _aliasLabel = aliasLabel;
    [self addSubview:aliasLabel];
    
    UIImageView *genderImageView = [UIImageView new];
    _genderImageView = genderImageView;
    [self addSubview:genderImageView];
    
    YYLabel *contentLabel = [YYLabel new];
    contentLabel.numberOfLines = 0;   // 开启多行显示
    contentLabel.preferredMaxLayoutWidth = SY_SCREEN_WIDTH - 120;
    contentLabel.font = SYRegularFont(13);
    contentLabel.textColor = SYColor(153, 153, 153);
    _contentLabel = contentLabel;
    [self addSubview:contentLabel];
    
    UIButton *likeBtn = [UIButton new];
    [likeBtn setImage:SYImageNamed(@"news_icon_good") forState:UIControlStateNormal];
    [likeBtn setImage:SYImageNamed(@"news_icon_good_selected") forState:UIControlStateSelected];
    _likeBtn = likeBtn;
    [self addSubview:likeBtn];
    
    UILabel *likeNumLabel = [UILabel new];
    likeNumLabel.textColor = SYColor(153, 153, 153);
    likeNumLabel.textAlignment = NSTextAlignmentCenter;
    _likeNumLabel = likeNumLabel;
    [self addSubview:likeNumLabel];
}

- (void)_makeSubViewsConstraints {
    [self.headPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(30);
    }];
    [self.aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headPhotoView.mas_right).offset(15);
        make.top.equalTo(self).offset(20);
        make.height.offset(17);
    }];
    [self.genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(15);
        make.left.equalTo(self.aliasLabel.mas_right).offset(15);
        make.centerY.equalTo(self.aliasLabel);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliasLabel);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(15);
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(15);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
        make.right.equalTo(self.likeNumLabel.mas_left).offset(-6);
        make.bottom.equalTo(self).offset(-15);
    }];
    [self.likeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.likeBtn);
        make.right.equalTo(self).offset(-30);
        make.width.offset(40);
    }];
}

@end
