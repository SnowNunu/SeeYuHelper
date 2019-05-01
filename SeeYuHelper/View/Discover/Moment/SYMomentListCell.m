//
//  SYMomentListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMomentListCell.h"
#import <YBImageBrowser/YBImageBrowser.h>

@implementation SYMomentListCell

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
    headImageView.masksToBounds = YES;
    headImageView.layer.cornerRadius = 22.5f;
    _headImageView = headImageView;
    [self.contentView addSubview:headImageView];
    
    YYLabel *aliasLabel = [YYLabel new];
    aliasLabel.numberOfLines = 0;   // 开启多行显示
    aliasLabel.preferredMaxLayoutWidth = SY_SCREEN_WIDTH - 90;
    aliasLabel.font = SYRegularFont(16);
    _aliasLabel = aliasLabel;
    [self.contentView addSubview:aliasLabel];
    
    YYLabel *contentLabel = [YYLabel new];
    contentLabel.numberOfLines = 0;   // 开启多行显示
    contentLabel.preferredMaxLayoutWidth = SY_SCREEN_WIDTH - 90;
    contentLabel.font = SYRegularFont(13);
    contentLabel.textColor = SYColor(153, 153, 153);
    _contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    UIView *photoContainerView = [UIView new];
    photoContainerView.backgroundColor = [UIColor whiteColor];
    _photoContainerView = photoContainerView;
    [self.contentView addSubview:photoContainerView];
    
    UIImageView *videoContainerView = [UIImageView new];
    videoContainerView.backgroundColor = [UIColor whiteColor];
    videoContainerView.userInteractionEnabled = YES;
    videoContainerView.contentMode = UIViewContentModeScaleAspectFill;
    videoContainerView.clipsToBounds = YES;
    [videoContainerView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _videoContainerView = videoContainerView;
    [self.contentView addSubview:videoContainerView];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.textColor = SYColor(153, 153, 153);
    timeLabel.font = SYRegularFont(15);
    timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
}

- (void)_makeSubViewsConstraints {
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.left.top.equalTo(self.contentView).offset(15);
    }];
    [self.aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.offset(20);
        make.left.equalTo(self.headImageView.mas_right).offset(15);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.photoContainerView.mas_top).offset(-15);
        make.left.right.equalTo(self.aliasLabel);
    }];
    [self.photoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.contentLabel);
        make.bottom.equalTo(self.videoContainerView.mas_top);
        make.height.offset(0);
    }];
    [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
        make.width.offset(50);
        make.left.equalTo(self.photoContainerView);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-15);
        make.left.right.equalTo(self.photoContainerView);
        make.height.offset(15);
    }];
}

// 根据传入的url分割
- (void)_setupPhotosViewByUrls:(NSString*)photosUrl {
    NSArray *photosArray = [photosUrl componentsSeparatedByString:@","];
    self.photos = [NSMutableArray arrayWithArray:photosArray];
    CGFloat width = (SY_SCREEN_WIDTH - 90 - 10) / 3;
    [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.contentLabel);
        make.bottom.equalTo(self.videoContainerView.mas_top).offset(-15);
        make.height.offset((photosArray.count - 1) / 3 * (width + 5) + width);
    }];
    for (int i = 0; i < photosArray.count; i++) {
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [photoView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        photoView.backgroundColor = [UIColor blueColor];
        photoView.tag = i;
        photoView.userInteractionEnabled = YES;
        [photoView yy_setImageWithURL:[NSURL URLWithString:photosArray[i]] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        [self.photoContainerView addSubview:photoView];
        
        // 添加手势监听器（一个手势监听器 只能 监听对应的一个view）
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(_tapPhoto:)];
        [photoView addGestureRecognizer:recognizer];
        recognizer.view.tag = i;
        
        [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(width);
            if (photosArray.count == 4) {
                make.left.equalTo(self.photoContainerView).offset(i % 2 * (width + 5));
                make.top.equalTo(self.photoContainerView).offset(i / 2 * (width + 5));
            } else {
                make.left.equalTo(self.photoContainerView).offset(i % 3 * (width + 5));
                make.top.equalTo(self.photoContainerView).offset(i / 3 * (width + 5));
            }
        }];
    }
}

- (void)_setupVideoShowViewBy:(NSString*)url {
    UIImageView *playImageView = [UIImageView new];
    playImageView.image = SYImageNamed(@"play_btn_normal_120x120");
    [self.videoContainerView addSubview:playImageView];
    [self.videoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(180);
    }];
    [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoContainerView);
        make.width.height.offset(40);
    }];
    self.videoUrl = [NSURL URLWithString:url];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [recognizer addTarget:self action:@selector(_tapVideo:)];
    [self.videoContainerView addGestureRecognizer:recognizer];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [[UIImage alloc] getVideoPreviewImage:[NSURL URLWithString:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.videoContainerView.image = image;
        });
    });
}

- (void)_tapPhoto:(UITapGestureRecognizer *)sender {
    /// 图片浏览
    NSMutableArray *item = [NSMutableArray new];
    for (int i = 0 ; i < self.photos.count; i++) {
        YBImageBrowseCellData *data = [YBImageBrowseCellData new];
        data.url = self.photos[i];
        data.sourceObject = [self viewWithTag:i];
        data.allowSaveToPhotoAlbum = NO;
        [item addObject:data];
    }
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = item;
    browser.currentIndex = sender.view.tag;
    [browser show];
}

- (void)_tapVideo:(UITapGestureRecognizer *)sender {
    YBVideoBrowseCellData *data = [YBVideoBrowseCellData new];
    data.url = self.videoUrl;
    data.sourceObject = self.videoContainerView;
    data.autoPlayCount = 1;
    data.allowSaveToPhotoAlbum = NO;
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = @[data];
    browser.currentIndex = 0;
    [browser show];
}

@end
