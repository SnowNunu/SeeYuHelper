//
//  SYCoverInfoEditVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYCoverInfoEditVC.h"
#import "SYUserInfoEditModel.h"

@interface SYCoverInfoEditVC ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UILabel *coverTips1Label;

@property (nonatomic, strong) UILabel *coverTips2Label;

@property (nonatomic, strong) UIButton *modifyCoverBtn;

@property (nonatomic, strong) ZYImagePicker *imagePicker;

@end

@implementation SYCoverInfoEditVC

- (ZYImagePicker *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[ZYImagePicker alloc]init];
        _imagePicker.resizableClipArea = NO;
        _imagePicker.clipSize = CGSizeMake(SY_SCREEN_WIDTH, SY_SCREEN_WIDTH);
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
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestUserShowInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, model) subscribeNext:^(SYUserInfoEditModel *model) {
        @strongify(self)
        if (model != nil) {
            if (model.showPhoto == nil || model.showPhoto.length == 0) {
                self.coverTips1Label.hidden = NO;
                self.coverTips2Label.hidden = NO;
                [self.modifyCoverBtn setTitle:@"添加封面" forState:UIControlStateNormal];
            } else {
                self.coverTips1Label.hidden = YES;
                self.coverTips2Label.hidden = YES;
                [self.modifyCoverBtn setTitle:@"修改封面" forState:UIControlStateNormal];
                self.coverImageView.yy_imageURL = [NSURL URLWithString:model.showPhoto];
            }
        }
    }];
    [[self.modifyCoverBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.viewModel.model.showPhoto == nil || ![self.viewModel.model.showPhotoStatus isEqualToString:@"0"]) {
            @strongify(self)
            __weak typeof(self) weakSelf = self;
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 0) return ;
                if (buttonIndex == 1) {
                    // 拍照
                    weakSelf.imagePicker.isCustomCamera = YES;
                    weakSelf.imagePicker.imageSorceType = sourceType_camera;
                    weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                        weakSelf.coverTips1Label.hidden = YES;
                        weakSelf.coverTips2Label.hidden = YES;
                        weakSelf.coverImageView.image = clippedImage;
                        [weakSelf.viewModel.uploadUserCoverCommand execute:[clippedImage resetSizeOfImageData:clippedImage maxSize:300]];
                    };
                    [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
                } else {
                    // 相册
                    weakSelf.imagePicker.isCustomCamera = YES;
                    weakSelf.imagePicker.imageSorceType = sourceType_SavedPhotosAlbum;
                    weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                        weakSelf.coverTips1Label.hidden = YES;
                        weakSelf.coverTips2Label.hidden = YES;
                        weakSelf.coverImageView.image = clippedImage;
                        [weakSelf.viewModel.uploadUserCoverCommand execute:[clippedImage resetSizeOfImageData:clippedImage maxSize:300]];
                    };
                    [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
                }
            } otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            [sheet show];
        } else {
            [MBProgressHUD sy_showTips:@"封面审核中,暂不能修改"];
        }
    }];
}

- (void)_setupSubviews {
    self.view.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    
    UIImageView *coverImageView = [UIImageView new];
    coverImageView.backgroundColor = SYColorAlpha(0, 0, 0, 0.05);
    _coverImageView = coverImageView;
    [self.view addSubview:coverImageView];
    
    UILabel *coverTips1Label = [UILabel new];
    coverTips1Label.textAlignment = NSTextAlignmentCenter;
    coverTips1Label.font = SYRegularFont(30);
    coverTips1Label.text = @"暂无封面";
    coverTips1Label.textColor = SYColor(153, 153, 153);
    _coverTips1Label = coverTips1Label;
    [self.view addSubview:coverTips1Label];
    
    UILabel *coverTips2Label = [UILabel new];
    coverTips2Label.textAlignment = NSTextAlignmentCenter;
    coverTips2Label.font = SYRegularFont(15);
    coverTips2Label.text = @"点击底部按钮添加";
    coverTips2Label.textColor = SYColor(153, 153, 153);
    _coverTips2Label = coverTips2Label;
    [self.view addSubview:coverTips2Label];
    
    UIButton *modifyCoverBtn = [UIButton new];
    [modifyCoverBtn setTitle:@"添加封面" forState:UIControlStateNormal];
    [modifyCoverBtn setTintColor:[UIColor whiteColor]];
    modifyCoverBtn.titleLabel.font = SYRegularFont(19);
    modifyCoverBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    _modifyCoverBtn = modifyCoverBtn;
    [self.view addSubview:modifyCoverBtn];
}

- (void)_makeSubViewsConstraints {
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(self.coverImageView.mas_width);
    }];
    [_coverTips1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverImageView);
        make.height.offset(30);
    }];
    [_coverTips2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.coverTips1Label.mas_bottom).offset(15);
        make.centerX.equalTo(self.coverTips1Label);
    }];
    [_modifyCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.offset(40);
    }];
}

@end
