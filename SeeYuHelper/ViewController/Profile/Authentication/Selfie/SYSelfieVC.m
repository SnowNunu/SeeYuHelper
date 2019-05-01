//
//  SYSelfieVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/15.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSelfieVC.h"

@interface SYSelfieVC ()

@property (nonatomic, strong) UILabel *takePhotoLabel;

@property (nonatomic, strong) UIImageView *takePhotoBgView;

@property (nonatomic, strong) UIImageView *takePhotoImageView;

@property (nonatomic, strong) UILabel *takePhotoTipsLabel;

@property (nonatomic, strong) UILabel *takeVideoLabel;

@property (nonatomic, strong) UIImageView *takeVideoBgView;

@property (nonatomic, strong) UIImageView *takeVideoImageView;

@property (nonatomic, strong) UILabel *takeVideoTipsLabel;

@property (nonatomic, strong) UIButton *uploadBtn;

@property (nonatomic, strong) ZYImagePicker *imagePicker;

@property (nonatomic, strong) NSURL *contentUrl;

@end

@implementation SYSelfieVC

- (ZYImagePicker *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[ZYImagePicker alloc]init];
        _imagePicker.resizableClipArea = NO;
        _imagePicker.clipSize = CGSizeMake(SY_SCREEN_WIDTH - 50, (SY_SCREEN_WIDTH - 50) * 1.5);
        _imagePicker.slideColor = [UIColor whiteColor];
        _imagePicker.slideWidth = 4;
        _imagePicker.slideLength = 40;
        _imagePicker.didSelectedImageBlock = ^BOOL(UIImage *selectedImage) {
            return YES;
        };
    }
    return _imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [[self.uploadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.takePhotoBgView.image == nil) {
            [MBProgressHUD sy_showTips:@"请先上传自拍照"];
        } else if (self.takeVideoBgView.image == nil) {
            [MBProgressHUD sy_showTips:@"请先上传自拍视频"];
        }
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:@{@"userId":self.viewModel.services.client.currentUser.userId}];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_SELFIE_UPLOAD parameters:subscript.dictionary];
        [MBProgressHUD sy_showProgressHUD:@"资料上传中，请稍候"];
        [[[self.viewModel.services.client enqueueUploadRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYSelfieModel class] fileDatas:@[[self.takePhotoBgView.image resetSizeOfImageData:self.takePhotoBgView.image maxSize:300],[NSData dataWithContentsOfURL:self.contentUrl]] namesArray:@[@"selfiePhoto-jpg",@"selfieVideo-mp4"] mimeType:nil] sy_parsedResults] subscribeNext:^(SYSelfieModel *model) {
            [MBProgressHUD sy_hideHUD];
            // 写入缓存，审核不通过的情况下可以显示之前的上传的文件记录
            YYCache *cache = [YYCache cacheWithName:@"seeyu"];
            [cache setObject:model forKey:@"SYSelfieModel"];
        } error:^(NSError *error) {
            [MBProgressHUD sy_showErrorTips:error];
        } completed:^{
            [MBProgressHUD sy_showTips:@"资料上传成功，请等待审核"];
            [self.viewModel.services popViewModelAnimated:YES];
        }];
    }];
}

- (void)_setupSubViews {
    UILabel *takePhotoLabel = [UILabel new];
    takePhotoLabel.textColor = SYColor(51, 51, 51);
    takePhotoLabel.font = SYRegularFont(18);
    takePhotoLabel.textAlignment = NSTextAlignmentLeft;
    takePhotoLabel.text = @"拍摄照片";
    _takePhotoLabel = takePhotoLabel;
    [self.view addSubview:takePhotoLabel];
    
    UIImageView *takePhotoBgView = [UIImageView new];
    takePhotoBgView.backgroundColor = SYColorFromHexString(@"#E9E9E9");
    takePhotoBgView.layer.borderWidth = 1.f;
    takePhotoBgView.layer.borderColor = SYColorFromHexString(@"#CCCCCC").CGColor;
    takePhotoBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *takePhotoTap = [UITapGestureRecognizer new];
    @weakify(self)
    [[takePhotoTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        __weak typeof(self) weakSelf = self;
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) return ;
            if (buttonIndex == 1) {
                // 拍照
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_camera;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    weakSelf.takePhotoBgView.image = clippedImage;
                    weakSelf.takePhotoImageView.hidden = YES;
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            } else {
                // 相册
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_SavedPhotosAlbum;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    weakSelf.takePhotoBgView.image = clippedImage;
                    weakSelf.takePhotoImageView.hidden = YES;
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            }
        } otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [sheet show];
    }];
    [takePhotoBgView addGestureRecognizer:takePhotoTap];
    _takePhotoBgView = takePhotoBgView;
    [self.view addSubview:takePhotoBgView];
    
    UIImageView *takePhotoImageView = [UIImageView new];
    takePhotoImageView.image = SYImageNamed(@"upload_plus");
    _takePhotoImageView = takePhotoImageView;
    [takePhotoBgView addSubview:takePhotoImageView];
    
    UILabel *takePhotoTipsLabel = [UILabel new];
    takePhotoTipsLabel.textColor = SYColor(153, 153, 153);
    takePhotoTipsLabel.font = SYRegularFont(12);
    takePhotoTipsLabel.textAlignment = NSTextAlignmentLeft;
    takePhotoTipsLabel.text = @"建议在网络良好状态下上传，并注意照片反光";
    _takePhotoTipsLabel = takePhotoTipsLabel;
    [self.view addSubview:takePhotoTipsLabel];
    
    UILabel *takeVideoLabel = [UILabel new];
    takeVideoLabel.textColor = SYColor(51, 51, 51);
    takeVideoLabel.font = SYRegularFont(18);
    takeVideoLabel.textAlignment = NSTextAlignmentLeft;
    takeVideoLabel.text = @"拍摄视频";
    _takeVideoLabel = takeVideoLabel;
    [self.view addSubview:takeVideoLabel];
    
    UIImageView *takeVideoBgView = [UIImageView new];
    takeVideoBgView.backgroundColor = SYColorFromHexString(@"#E9E9E9");
    takeVideoBgView.layer.borderWidth = 1.f;
    takeVideoBgView.layer.borderColor = SYColorFromHexString(@"#CCCCCC").CGColor;
    takeVideoBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *takeVideoTap = [UITapGestureRecognizer new];
    [[takeVideoTap rac_gestureSignal] subscribeNext:^(id x) {
        YLShortVideoVC *videoVC = [YLShortVideoVC new];
        videoVC.shortVideoBack = ^(NSURL *videoUrl) {
            self.takeVideoImageView.hidden = YES;
            self.contentUrl = videoUrl;
            self.takeVideoBgView.image = [UIImage sy_thumbnailImageForVideo:videoUrl atTime:1];
        };
        [self presentViewController:videoVC animated:YES completion:nil];
    }];
    [takeVideoBgView addGestureRecognizer:takeVideoTap];
    _takeVideoBgView = takeVideoBgView;
    [self.view addSubview:takeVideoBgView];
    
    UIImageView *takeVideoImageView = [UIImageView new];
    takeVideoImageView.image = SYImageNamed(@"upload_plus");
    _takeVideoImageView = takeVideoImageView;
    [self.view addSubview:takeVideoImageView];
    
    UILabel *takeVideoTipsLabel = [UILabel new];
    takeVideoTipsLabel.textColor = SYColor(153, 153, 153);
    takeVideoTipsLabel.font = SYRegularFont(12);
    takeVideoTipsLabel.textAlignment = NSTextAlignmentLeft;
    takeVideoTipsLabel.text = @"保持正面拍摄5秒钟";
    _takeVideoTipsLabel = takeVideoTipsLabel;
    [self.view addSubview:takeVideoTipsLabel];
    
    UIButton *uploadBtn = [UIButton new];
    [uploadBtn setBackgroundColor:SYColorFromHexString(@"#9F69EB")];
    [uploadBtn setTitle:@"提交" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = SYRegularFont(18);
    _uploadBtn = uploadBtn;
    [self.view addSubview:uploadBtn];
}

- (void)_makeSubViewsConstraints {
    [_takePhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(15);
        make.height.offset(20);
    }];
    CGFloat height = (SY_SCREEN_HEIGHT - SY_APPLICATION_TOP_BAR_HEIGHT - 225) / 2;
    [_takePhotoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height);
        make.width.equalTo(self.takePhotoBgView.mas_height).multipliedBy(0.666);
        make.left.equalTo(self.takePhotoLabel);
        make.top.equalTo(self.takePhotoLabel.mas_bottom).offset(15);
    }];
    [_takePhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.takePhotoBgView);
        make.width.height.offset(33);
    }];
    [_takePhotoTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takePhotoBgView.mas_bottom).offset(15);
        make.left.equalTo(self.takePhotoBgView);
        make.height.offset(15);
    }];
    [_takeVideoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.takePhotoTipsLabel.mas_bottom).offset(15);
        make.height.offset(20);
    }];
    [_takeVideoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.left.equalTo(self.takePhotoBgView);
        make.top.equalTo(self.takeVideoLabel.mas_bottom).offset(15);
    }];
    [_takeVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.takeVideoBgView);
        make.width.height.offset(33);
    }];
    [_takeVideoTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takeVideoBgView.mas_bottom).offset(15);
        make.left.equalTo(self.takePhotoBgView);
        make.height.offset(15);
    }];
    [_uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
}

@end

