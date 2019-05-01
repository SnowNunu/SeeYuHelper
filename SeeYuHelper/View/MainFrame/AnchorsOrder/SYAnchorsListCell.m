//
//  SYAnchorsListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsListCell.h"

@implementation SYAnchorsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    UIImageView *headImageView = [UIImageView new];
//     //  居中显示
//    headImageView.contentMode = UIViewContentModeScaleAspectFill;
//    headImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    headImageView.clipsToBounds = YES;
    _headImageView = headImageView;
    [self.contentView addSubview:headImageView];
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = SYImageNamed(@"shadow_bottom");
    _bgImageView = bgImageView;
    [self.contentView addSubview:bgImageView];
    
    UIImageView *onlineStatusImageView = [UIImageView new];
    _onlineStatusImageView = onlineStatusImageView;
    [self.contentView addSubview:onlineStatusImageView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.textColor = [UIColor whiteColor];
    aliasLabel.font = SYRegularFont(15);
    _aliasLabel = aliasLabel;
    [bgImageView addSubview:aliasLabel];
    
    UIImageView *voiceImageView = [UIImageView new];
    voiceImageView.image = SYImageNamed(@"home_icon_live");
    _voiceImageView = voiceImageView;
    [bgImageView addSubview:voiceImageView];
    
    UILabel *voicePriceLabel = [UILabel new];
    voicePriceLabel.textAlignment = NSTextAlignmentRight;
    voicePriceLabel.textColor = [UIColor whiteColor];
    voicePriceLabel.font = SYRegularFont(13);
    _voicePriceLabel = voicePriceLabel;
    [bgImageView addSubview:voicePriceLabel];
    
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    signatureLabel.textColor = [UIColor whiteColor];
    signatureLabel.font = SYRegularFont(14);
    _signatureLabel = signatureLabel;
    [bgImageView addSubview:signatureLabel];
    
    // 添加毛玻璃效果
    UIVisualEffectView *visual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visual.frame = bgImageView.bounds;
    visual.alpha = 0.8f;
    [bgImageView addSubview:visual];
}

- (void)_makeSubViewsConstraints {
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.onlineStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.offset(50);
        make.height.offset(20);
    }];
    [self.aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.width.offset(SY_SCREEN_WIDTH * 0.5 - 15);
        make.height.offset(15);
        make.bottom.equalTo(self.signatureLabel.mas_top).offset(-20);
    }];
    [self.voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(15);
        make.height.offset(12);
        make.right.equalTo(self.voicePriceLabel.mas_left).offset(-15);
        make.centerY.equalTo(self.aliasLabel);
    }];
    [self.voicePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.width.offset(80);
        make.top.height.equalTo(self.aliasLabel);
    }];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.bottom.equalTo(self.contentView).offset(-15);
        make.height.offset(15);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.aliasLabel.mas_top).offset(-20);
    }];
}

- (void)setTipsByHobby:(NSString*)hobby {
    NSArray *hobbiesArray = [hobby componentsSeparatedByString:@","];
    if (hobbiesArray.count > 0 && hobbiesArray.count <= 3) {
        for (int i = 0; i < hobbiesArray.count; i++) {
            UILabel *tipsLabel = [UILabel new];
            tipsLabel.textColor = [UIColor whiteColor];
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.font = SYRegularFont(14);
            tipsLabel.layer.masksToBounds = YES;
            tipsLabel.layer.cornerRadius = 10.f;
            tipsLabel.text = hobbiesArray[i];
            if (i == 0) {
                tipsLabel.backgroundColor = SYColorFromHexString(@"#9F69EB");
            } else if (i == 1) {
                tipsLabel.backgroundColor = SYColorFromHexString(@"#F7A7CD");
            } else {
                tipsLabel.backgroundColor = SYColorFromHexString(@"#FF3EA3");
            }
            [self.contentView addSubview:tipsLabel];
            
            [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(65);
                make.height.offset(20);
                make.left.equalTo(self.aliasLabel).offset(i * 75);
                make.bottom.equalTo(self.aliasLabel.mas_top).offset(-15);
            }];
        }
    }
}

- (void)setStarsByLevel:(int)level {
    for (int i = 0; i < level; i++) {
        UIImageView *starImageView = [UIImageView new];
        starImageView.image= SYImageNamed(@"home_icon_star");
        [self.contentView addSubview:starImageView];
        [starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.equalTo(self.aliasLabel).offset(i * 20);
            make.centerY.equalTo(self.onlineStatusImageView);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
