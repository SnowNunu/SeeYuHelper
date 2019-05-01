//
//  SYRealnameVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/15.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYRealnameVC.h"
#import "NSString+SYValid.h"
#import "SYUserIdentityAuth.h"

@interface SYRealnameVC ()

@property (nonatomic, strong) UILabel *realnameLabel;

@property (nonatomic, strong) UITextField *realnameTextField;

@property (nonatomic, strong) UIImageView *underlineImageView;

@property (nonatomic, strong) UILabel *idNumberLabel;

@property (nonatomic, strong) UITextField *idNumberTextField;

@property (nonatomic, strong) UILabel *uploadIdCardLabel;

@property (nonatomic, strong) UIButton *idCardBackBtn;

@property (nonatomic, strong) UIImage *idCardBackImage;

@property (nonatomic, strong) UILabel *idCardBackLabel;

@property (nonatomic, strong) UIButton *idCardFrontBtn;

@property (nonatomic, strong) UIImage *idCardFrontImage;

@property (nonatomic, strong) UILabel *idCardFrontLabel;

@property (nonatomic, strong) UIButton *idCardHandBtn;

@property (nonatomic, strong) UIImage *idCardHandImage;

@property (nonatomic, strong) UILabel *idCardHandLabel;

@property (nonatomic, strong) UILabel *uploadIdCardHandLabel;

@property (nonatomic, strong) UIButton *uploadBtn;

@property (nonatomic, strong) ZYImagePicker *imagePicker;

@end

@implementation SYRealnameVC

- (ZYImagePicker *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[ZYImagePicker alloc]init];
        _imagePicker.resizableClipArea = NO;
        _imagePicker.clipSize = CGSizeMake(SY_SCREEN_WIDTH, SY_SCREEN_WIDTH / 3 * 2);
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
    [self checkCache];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [[self.idCardBackBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        __weak typeof(self) weakSelf = self;
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) return ;
            if (buttonIndex == 1) {
                // 拍照
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_camera;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    weakSelf.idCardBackImage = clippedImage;
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            } else {
                // 相册
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_SavedPhotosAlbum;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    weakSelf.idCardBackImage = clippedImage;
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            }
        } otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [sheet show];
    }];
    [[self.idCardFrontBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        __weak typeof(self) weakSelf = self;
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) return ;
            if (buttonIndex == 1) {
                // 拍照
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_camera;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    weakSelf.idCardFrontImage = clippedImage;
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            } else {
                // 相册
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_SavedPhotosAlbum;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    weakSelf.idCardFrontImage = clippedImage;
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            }
        } otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [sheet show];
    }];
    [[self.idCardHandBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        __weak typeof(self) weakSelf = self;
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) return ;
            if (buttonIndex == 1) {
                // 拍照
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_camera;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    weakSelf.idCardHandImage = clippedImage;
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            } else {
                // 相册
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_SavedPhotosAlbum;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    weakSelf.idCardHandImage = clippedImage;
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            }
        } otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [sheet show];
    }];
    [[self.uploadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.realnameTextField.text.length == 0) {
            [MBProgressHUD sy_showTips:@"请先输入真实姓名"];
            return;
        } else if (![NSString sy_isContainChinese:self.realnameTextField.text]) {
            [MBProgressHUD sy_showTips:@"请输入正确的姓名"];
            return;
        }
        if (self.idNumberTextField.text.length == 0) {
            [MBProgressHUD sy_showTips:@"请先输入身份证号码"];
            return;
        } else if (![NSString sy_validateIDCardNumber:self.idNumberTextField.text]) {
            [MBProgressHUD sy_showTips:@"请输入正确的身份证号码"];
            return;
        }
        if (self.idCardBackImage == nil) {
            [MBProgressHUD sy_showTips:@"请先上传身份证背面照"];
            return;
        }
        if (self.idCardFrontImage == nil) {
            [MBProgressHUD sy_showTips:@"请先上传身份证正面照"];
            return;
        }
        if (self.idCardHandImage == nil) {
            [MBProgressHUD sy_showTips:@"请先上传身份证手持照"];
            return;
        }
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:@{@"userId":self.viewModel.services.client.currentUser.userId,@"userRealName":self.realnameTextField.text,@"userIdCard":self.idNumberTextField.text}];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_IDENTITY_UPLOAD parameters:subscript.dictionary];
        [MBProgressHUD sy_showProgressHUD:@"资料上传中，请稍候"];
        [[[self.viewModel.services.client enqueueUploadRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUserIdentityAuth class] fileDatas:@[[self.idCardBackImage resetSizeOfImageData:self.idCardBackImage maxSize:300],[self.idCardFrontImage resetSizeOfImageData:self.idCardFrontImage maxSize:300],[self.idCardHandImage resetSizeOfImageData:self.idCardHandImage maxSize:300]] namesArray:@[@"idBehind-jpg",@"idFront-jpg",@"idWithUser-jpg"] mimeType:@"image/png"] sy_parsedResults] subscribeNext:^(SYUserIdentityAuth *auth) {
            [MBProgressHUD sy_hideHUD];
            // 写入缓存，审核不通过的情况下可以显示之前的上传的文件记录
            YYCache *cache = [YYCache cacheWithName:@"seeyu"];
            [cache setObject:auth forKey:@"SYUserIdentityAuth"];
        } error:^(NSError *error) {
            [MBProgressHUD sy_showErrorTips:error];
        } completed:^{
            [MBProgressHUD sy_showTips:@"资料上传成功，请等待审核"];
            [self.viewModel.services popViewModelAnimated:YES];
        }];
    }];
    [RACObserve(self, idCardBackImage) subscribeNext:^(UIImage *image) {
        if (image != nil) {
            [self.idCardBackBtn setImage:image forState:UIControlStateNormal];
        }
    }];
    [RACObserve(self, idCardFrontImage) subscribeNext:^(UIImage *image) {
        if (image != nil) {
            [self.idCardFrontBtn setImage:image forState:UIControlStateNormal];
        }
    }];
    [RACObserve(self, idCardHandImage) subscribeNext:^(UIImage *image) {
        if (image != nil) {
            [self.idCardHandBtn setImage:image forState:UIControlStateNormal];
        }
    }];
}

- (void)_setupSubViews {
    UILabel *realnameLabel = [UILabel new];
    realnameLabel.textColor = SYColor(51, 51, 51);
    realnameLabel.font = SYRegularFont(16);
    realnameLabel.textAlignment = NSTextAlignmentLeft;
    realnameLabel.text = @"真实姓名";
    _realnameLabel = realnameLabel;
    [self.view addSubview:realnameLabel];
    
    UITextField *realnameTextField = [UITextField new];
    realnameTextField.placeholder = @"请输入真实姓名";
    realnameTextField.textAlignment = NSTextAlignmentLeft;
    realnameTextField.font = SYRegularFont(14);
    _realnameTextField = realnameTextField;
    [self.view addSubview:realnameTextField];
    
    UIImageView *underlineImageView = [UIImageView new];
    underlineImageView.backgroundColor = SYColorFromHexString(@"#CCCCCC");
    _underlineImageView = underlineImageView;
    [self.view addSubview:underlineImageView];
    
    UILabel *idNumberLabel = [UILabel new];
    idNumberLabel.textColor = SYColor(51, 51, 51);
    idNumberLabel.font = SYRegularFont(16);
    idNumberLabel.textAlignment = NSTextAlignmentLeft;
    idNumberLabel.text = @"身份证号";
    _idNumberLabel = idNumberLabel;
    [self.view addSubview:idNumberLabel];
    
    UITextField *idNumberTextField = [UITextField new];
    idNumberTextField.placeholder = @"请输入身份证号码";
    idNumberTextField.textAlignment = NSTextAlignmentLeft;
    idNumberTextField.font = SYRegularFont(14);
    _idNumberTextField = idNumberTextField;
    [self.view addSubview:idNumberTextField];
    
    UILabel *uploadIdCardLabel = [UILabel new];
    uploadIdCardLabel.textColor = SYColor(51, 51, 51);
    uploadIdCardLabel.font = SYRegularFont(16);
    uploadIdCardLabel.textAlignment = NSTextAlignmentLeft;
    uploadIdCardLabel.text = @"上传身份证";
    _uploadIdCardLabel = uploadIdCardLabel;
    [self.view addSubview:uploadIdCardLabel];
    
    UIButton *idCardBackBtn = [UIButton new];
    [idCardBackBtn setImage:SYImageNamed(@"upload_back") forState:UIControlStateNormal];
    _idCardBackBtn = idCardBackBtn;
    [self.view addSubview:idCardBackBtn];
    
    UILabel *idCardBackLabel = [UILabel new];
    idCardBackLabel.textColor = SYColor(51, 51, 51);
    idCardBackLabel.font = SYRegularFont(16);
    idCardBackLabel.textAlignment = NSTextAlignmentCenter;
    idCardBackLabel.text = @"背面";
    _idCardBackLabel = idCardBackLabel;
    [self.view addSubview:idCardBackLabel];
    
    UIButton *idCardFrontBtn = [UIButton new];
    [idCardFrontBtn setImage:SYImageNamed(@"upload_front") forState:UIControlStateNormal];
    _idCardFrontBtn = idCardFrontBtn;
    [self.view addSubview:idCardFrontBtn];
    
    UILabel *idCardFrontLabel = [UILabel new];
    idCardFrontLabel.textColor = SYColor(51, 51, 51);
    idCardFrontLabel.font = SYRegularFont(16);
    idCardFrontLabel.textAlignment = NSTextAlignmentCenter;
    idCardFrontLabel.text = @"正面";
    _idCardFrontLabel = idCardFrontLabel;
    [self.view addSubview:idCardFrontLabel];
    
    UILabel *uploadIdCardHandLabel = [UILabel new];
    uploadIdCardHandLabel.textColor = SYColor(51, 51, 51);
    uploadIdCardHandLabel.font = SYRegularFont(16);
    uploadIdCardHandLabel.textAlignment = NSTextAlignmentLeft;
    uploadIdCardHandLabel.text = @"上传手持身份证";
    _uploadIdCardHandLabel = uploadIdCardHandLabel;
    [self.view addSubview:uploadIdCardHandLabel];
    
    UIButton *idCardHandBtn = [UIButton new];
    [idCardHandBtn setImage:SYImageNamed(@"upload_handle") forState:UIControlStateNormal];
    _idCardHandBtn = idCardHandBtn;
    [self.view addSubview:idCardHandBtn];
    
    UIButton *uploadBtn = [UIButton new];
    [uploadBtn setBackgroundColor:SYColorFromHexString(@"#9F69EB")];
    [uploadBtn setTitle:@"提交" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = SYRegularFont(18);
    _uploadBtn = uploadBtn;
    [self.view addSubview:uploadBtn];
}

- (void)_makeSubViewsConstraints {
    [_realnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(15);
        make.height.offset(15);
        make.width.offset(65);
    }];
    [_realnameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.realnameLabel.mas_right).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.centerY.height.equalTo(self.realnameLabel);
    }];
    [_underlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.height.offset(1);
        make.top.equalTo(self.view).offset(45);
    }];
    [_idNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.equalTo(self.realnameLabel);
        make.top.equalTo(self.underlineImageView.mas_bottom).offset(15);
    }];
    [_idNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.realnameTextField);
        make.centerY.height.equalTo(self.idNumberLabel);
    }];
    [_uploadIdCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idNumberLabel.mas_bottom).offset(45);
        make.left.equalTo(self.view).offset(15);
        make.height.offset(15);
    }];
    [_idCardBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uploadIdCardLabel.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.width.offset((SY_SCREEN_WIDTH - 45) / 2);
        make.height.equalTo(self.idCardBackBtn.mas_width).multipliedBy(0.63);
    }];
    [_idCardBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idCardBackBtn.mas_bottom).offset(5);
        make.centerX.equalTo(self.idCardBackBtn);
        make.height.offset(15);
    }];
    [_idCardFrontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.idCardBackBtn);
        make.right.equalTo(self.view).offset(-15);
    }];
    [_idCardFrontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.idCardBackLabel);
        make.centerX.equalTo(self.idCardFrontBtn);
    }];
    [_uploadIdCardHandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idCardFrontLabel.mas_bottom).offset(45);
        make.height.offset(15);
        make.left.equalTo(self.uploadIdCardLabel);
    }];
    [_idCardHandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.left.equalTo(self.idCardBackBtn);
        make.top.equalTo(self.uploadIdCardHandLabel.mas_bottom).offset(15);
    }];
    [_uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
}

// 审核不通过的情况下读取之前的缓存显示
- (void)checkCache {
    YYCache *cache = [YYCache cacheWithName:@"seeyu"];
    if ([cache containsObjectForKey:@"SYUserIdentityAuth"]) {
        id auth = [cache objectForKey:@"SYUserIdentityAuth"];
        SYUserIdentityAuth *identityAuth = (SYUserIdentityAuth*)auth;
        self.realnameTextField.text = identityAuth.identityRealname;
        self.idNumberTextField.text = identityAuth.identityIdcardNum;
        self.idCardBackImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:identityAuth.identityIdBehind]]];
        self.idCardFrontImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:identityAuth.identityIdFront]]];
        self.idCardHandImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:identityAuth.identityIdWithUser]]];
    }
}

@end
