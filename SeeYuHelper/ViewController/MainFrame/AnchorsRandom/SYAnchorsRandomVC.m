//
//  SYAnchorsRandomVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/20.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsRandomVC.h"
#import "SYListVideoPlayer.h"
#import "PBJVision.h"
#import "HYBImageCliped.h"

@interface SYAnchorsRandomVC () <PBJVisionDelegate>

/* 背景图层 */
@property (nonatomic, strong) UIView *bgView;

/* 头像显示 */
@property (nonatomic, strong) UIImageView *headImageView;

/* 头像显示 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

/* 相机预览页 */
@property (nonatomic, strong) UIView *previewView;

/* 视频连线 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 想连就连 */
@property (nonatomic, strong) UILabel *tipsLabel;

/* 在线人数文本 */
@property (nonatomic, strong) UILabel *onlineAmountLabel;

/* 第1个主播视频页面 */
@property (nonatomic, strong) UIImageView *firstAnchorView;

/* 第1个主播视频链接 */
@property (nonatomic, strong) NSString *firstAnchorUrl;

/* 第1个主播视频背景 */
@property (nonatomic, strong) UIView *firstBgView;

/* 切换主播按钮 */
@property (nonatomic, strong) UIButton *firstChangeBtn;

/* 第1个主播爱好 */
@property (nonatomic, strong) UILabel *firstHobbyLabel;

/* 第1个主播语聊价格 */
@property (nonatomic, strong) UILabel *firstPriceLabel;

/* 第2个主播视频页面 */
@property (nonatomic, strong) UIImageView *secondAnchorView;

/* 切换主播按钮 */
@property (nonatomic, strong) UIButton *secondChangeBtn;

/* 第2个主播视频链接 */
@property (nonatomic, strong) NSString *secondAnchorUrl;

/* 第2个主播视频背景 */
@property (nonatomic, strong) UIView *secondBgView;

/* 第2个主播爱好 */
@property (nonatomic, strong) UILabel *secondHobbyLabel;

/* 第2个主播语聊价格 */
@property (nonatomic, strong) UILabel *secondPriceLabel;

/* 第3个主播视频页面 */
@property (nonatomic, strong) UIImageView *thirdAnchorView;

/* 切换主播按钮 */
@property (nonatomic, strong) UIButton *thirdChangeBtn;

/* 第3个主播视频链接 */
@property (nonatomic, strong) NSString *thirdAnchorUrl;

/* 第3个主播视频背景 */
@property (nonatomic, strong) UIView *thirdBgView;

/* 第3个主播爱好 */
@property (nonatomic, strong) UILabel *thirdHobbyLabel;

/* 第3个主播语聊价格 */
@property (nonatomic, strong) UILabel *thirdPriceLabel;

/* 随机抽取出的主播下标数组 */
@property (nonatomic, strong) NSArray *anchorsIndexArray;

/* 随机按钮 */
@property (nonatomic, strong) UIButton *randomBtn;

@end

@implementation SYAnchorsRandomVC

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    @weakify(self)
    [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        @strongify(self)
        /// 请求所有在线主播列表
        [self.viewModel.requestOnlineAnchorsList execute:nil];
    }];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self collectHeadImage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[PBJVision sharedInstance] stopPreview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[SYListVideoPlayer sharedPlayer] cancelAllVideo];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, onlineNumber) subscribeNext:^(NSString *number) {
        @strongify(self)
        self.onlineAmountLabel.text = [NSString stringWithFormat:@"当前在线 (%@人)",number];
    }];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        @strongify(self)
        if (array.count >= 3) {
            [self randomSelectAnchors];
        }
    }];
    [RACObserve(self, anchorsIndexArray) subscribeNext:^(NSArray *array) {
        @strongify(self)
        if (array.count == 3) {
            NSNumber *index0 = array[0];
            SYAnchorRandomCellModel *model0 = self.viewModel.datasource[[index0 intValue]];
            if (![model0.showVideo isEqualToString:self.firstAnchorUrl]) {
                [[SYListVideoPlayer sharedPlayer] cancelVideo:[self returnFilePathByUrl:self.firstAnchorUrl]];
                self.firstAnchorUrl = model0.showVideo;
            }
            NSNumber *index1 = array[1];
            SYAnchorRandomCellModel *model1 = self.viewModel.datasource[[index1 intValue]];
            if (![model1.showVideo isEqualToString:self.secondAnchorUrl]) {
                [[SYListVideoPlayer sharedPlayer] cancelVideo:[self returnFilePathByUrl:self.self.secondAnchorUrl]];
                self.secondAnchorUrl = model1.showVideo;
            }
            NSNumber *index2 = array[2];
            SYAnchorRandomCellModel *model2 = self.viewModel.datasource[[index2 intValue]];
            if (![model2.showVideo isEqualToString:self.thirdAnchorUrl]) {
                [[SYListVideoPlayer sharedPlayer] cancelVideo:[self returnFilePathByUrl:self.self.self.thirdAnchorUrl]];
                self.thirdAnchorUrl = model2.showVideo;
            }
        }
    }];
    [RACObserve(self,firstAnchorUrl) subscribeNext:^(NSString *url) {
        @strongify(self)
        if (![url sy_isNullOrNil] && url.length > 0) {
            if ([FCFileManager existsItemAtPath:[self returnFilePathByUrl:url]]) {
                NSLog(@"已经存在,filepath,%@",[self returnFilePathByUrl:url]);
                [self playVideo:[self returnFilePathByUrl:url] andIndex:0];
            } else {
                NSLog(@"开始下载:url%@,filepath:%@",url,[self returnFilePathByUrl:url]);
                [HYBNetworking downloadWithUrl:url saveToPath:[self returnFilePathByUrl:url] progress:^(int64_t bytesRead, int64_t totalBytesRead) {
                    
                } success:^(NSString *filePath) {
                    NSLog(@"下载完成:url%@,filepath:%@",url,[self returnFilePathByUrl:url]);
                    [self playVideo:[self returnFilePathByUrl:url] andIndex:0];
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
            // 更改视频的同时更改爱好和价格
            NSNumber *index = self.anchorsIndexArray[0];
            SYAnchorRandomCellModel *model = self.viewModel.datasource[[index intValue]];
            self.firstPriceLabel.text = [NSString stringWithFormat:@"%@钻石/分钟",model.anchorChatCost];
            self.firstHobbyLabel.text = [model.userSpecialty stringByReplacingOccurrencesOfString:@","withString:@" "];
        }
    }];
    [RACObserve(self,secondAnchorUrl) subscribeNext:^(NSString *url) {
        if (![url sy_isNullOrNil] && url.length >0) {
            if ([FCFileManager existsItemAtPath:[self returnFilePathByUrl:url]]) {
//                NSLog([NSString stringWithFormat:@"已经存在%@",[self returnFilePathByUrl:url]]);
                NSLog(@"已经存在,filepath,%@",[self returnFilePathByUrl:url]);
                [self playVideo:[self returnFilePathByUrl:url] andIndex:1];
            } else {
                NSLog(@"开始下载:url%@,filepath:%@",url,[self returnFilePathByUrl:url]);
                [HYBNetworking downloadWithUrl:url saveToPath:[self returnFilePathByUrl:url] progress:^(int64_t bytesRead, int64_t totalBytesRead) {
                    
                } success:^(NSString *filePath) {
                    NSLog(@"下载完成:url%@,filepath:%@",url,[self returnFilePathByUrl:url]);
                    [self playVideo:[self returnFilePathByUrl:url] andIndex:1];
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
            // 更改视频的同时更改爱好和价格
            NSNumber *index = self.anchorsIndexArray[1];
            SYAnchorRandomCellModel *model = self.viewModel.datasource[[index intValue]];
            self.secondPriceLabel.text = [NSString stringWithFormat:@"%@钻石/分钟",model.anchorChatCost];
            self.secondHobbyLabel.text = [model.userSpecialty stringByReplacingOccurrencesOfString:@","withString:@" "];
        }
    }];
    [RACObserve(self,thirdAnchorUrl) subscribeNext:^(NSString *url) {
        if (![url sy_isNullOrNil] && url.length >0) {
            if ([FCFileManager existsItemAtPath:[self returnFilePathByUrl:url]]) {
                NSLog(@"已经存在,filepath,%@",[self returnFilePathByUrl:url]);
                [self playVideo:[self returnFilePathByUrl:url] andIndex:2];
            } else {
                NSLog(@"开始下载:url%@,filepath:%@",url,[self returnFilePathByUrl:url]);
                [HYBNetworking downloadWithUrl:url saveToPath:[self returnFilePathByUrl:url] progress:^(int64_t bytesRead, int64_t totalBytesRead) {
                    
                } success:^(NSString *filePath) {
                    NSLog(@"下载完成:url%@,filepath:%@",url,[self returnFilePathByUrl:url]);
                    [self playVideo:[self returnFilePathByUrl:url] andIndex:2];
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
            // 更改视频的同时更改爱好和价格
            NSNumber *index = self.anchorsIndexArray[2];
            SYAnchorRandomCellModel *model = self.viewModel.datasource[[index intValue]];
            self.thirdPriceLabel.text = [NSString stringWithFormat:@"%@钻石/分钟",model.anchorChatCost];
            self.thirdHobbyLabel.text = [model.userSpecialty stringByReplacingOccurrencesOfString:@","withString:@" "];
        }
    }];
    [[self.randomBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 点击了换一换按钮
//        [[SYListVideoPlayer sharedPlayer] cancelAllVideo];
        [self randomSelectAnchors];
    }];
    [[self.firstChangeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.anchorsIndexArray];
        int i = arc4random() % [self.viewModel.datasource count];
        while ([[NSNumber numberWithInt:i] isEqualToNumber:self.anchorsIndexArray[0]] ||[[NSNumber numberWithInt:i] isEqualToNumber:self.anchorsIndexArray[1]] || [[NSNumber numberWithInt:i] isEqualToNumber:self.anchorsIndexArray[2]]) {
            i = arc4random() % [self.viewModel.datasource count];
        }
        [array replaceObjectAtIndex:0 withObject:@(i)];
        self.anchorsIndexArray = [NSArray arrayWithArray:array];
    }];
    [[self.secondChangeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.anchorsIndexArray];
        int i = arc4random() % [self.viewModel.datasource count];
        while ([[NSNumber numberWithInt:i] isEqualToNumber:self.anchorsIndexArray[0]] ||[[NSNumber numberWithInt:i] isEqualToNumber:self.anchorsIndexArray[1]] || [[NSNumber numberWithInt:i] isEqualToNumber:self.anchorsIndexArray[2]]) {
            i = arc4random() % [self.viewModel.datasource count];
        }
        [array replaceObjectAtIndex:1 withObject:@(i)];
        self.anchorsIndexArray = [NSArray arrayWithArray:array];
    }];
    [[self.thirdChangeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.anchorsIndexArray];
        int i = arc4random() % [self.viewModel.datasource count];
        while ([[NSNumber numberWithInt:i] isEqualToNumber:self.anchorsIndexArray[0]] ||[[NSNumber numberWithInt:i] isEqualToNumber:self.anchorsIndexArray[1]] || [[NSNumber numberWithInt:i] isEqualToNumber:self.anchorsIndexArray[2]]) {
            i = arc4random() % [self.viewModel.datasource count];
        }
        [array replaceObjectAtIndex:2 withObject:@(i)];
        self.anchorsIndexArray = [NSArray arrayWithArray:array];
    }];
}

- (void)_setupSubviews {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = SYColorFromHexString(@"#333333");
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.image = SYImageNamed(@"home_Head frame_self");
    _headImageView = headImageView;
    [bgView addSubview:headImageView];
    
    _previewView = [UIView new];
    _previewView.backgroundColor = [UIColor blackColor];
    _previewView.layer.masksToBounds = YES;
    _previewView.layer.cornerRadius = 60;
    CGRect previewFrame = CGRectMake((SY_SCREEN_WIDTH - 120) / 2, 15, 120, 120);
    _previewView.frame = previewFrame;
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.cornerRadius = 60;
    [_previewView.layer addSublayer:_previewLayer];
    [self.view addSubview:self.previewView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"自选视频";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = SYRegularFont(20);
    _titleLabel = titleLabel;
    [bgView addSubview:titleLabel];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.text = @"视频连线 想连就连";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = SYRegularFont(18);
    _tipsLabel = tipsLabel;
    [bgView addSubview:tipsLabel];
    
    UILabel *onlineAmountLabel = [UILabel new];
    onlineAmountLabel.textColor = SYColor(154, 102, 224);
    onlineAmountLabel.textAlignment = NSTextAlignmentLeft;
    onlineAmountLabel.font = SYRegularFont(16);
    _onlineAmountLabel = onlineAmountLabel;
    [bgView addSubview:onlineAmountLabel];
    
    UIImageView *firstAnchorView = [UIImageView new];
    firstAnchorView.layer.masksToBounds = YES;
    firstAnchorView.layer.cornerRadius = 5.f;
    firstAnchorView.userInteractionEnabled = YES;
    _firstAnchorView = firstAnchorView;
    [bgView addSubview:firstAnchorView];
    
    UIButton *firstChangeBtn = [UIButton new];
    [firstChangeBtn setImage:SYImageNamed(@"home_btn_close") forState:UIControlStateNormal];
    _firstChangeBtn = firstChangeBtn;
    [firstAnchorView addSubview:firstChangeBtn];
    
    UIView *firstBgView = [UIView new];
    firstBgView.backgroundColor = SYColorAlpha(0, 0, 0, 0.5);
    _firstBgView = firstBgView;
    [firstAnchorView addSubview:firstBgView];
    
    UILabel *firstHobbyLabel = [UILabel new];
    firstHobbyLabel.textColor = [UIColor whiteColor];
    firstHobbyLabel.textAlignment = NSTextAlignmentLeft;
    firstHobbyLabel.font =SYRegularFont(11);
    _firstHobbyLabel = firstHobbyLabel;
    [firstAnchorView addSubview:firstHobbyLabel];
    
    UILabel *firstPriceLabel = [UILabel new];
    firstPriceLabel.textColor = [UIColor whiteColor];
    firstPriceLabel.textAlignment = NSTextAlignmentLeft;
    firstPriceLabel.font =SYRegularFont(11);
    _firstPriceLabel = firstPriceLabel;
    [firstAnchorView addSubview:firstPriceLabel];

    UIImageView *secondAnchorView = [UIImageView new];
    secondAnchorView.layer.masksToBounds = YES;
    secondAnchorView.layer.cornerRadius = 5.f;
    secondAnchorView.userInteractionEnabled = YES;
    _secondAnchorView = secondAnchorView;
    [bgView addSubview:secondAnchorView];
    
    UIButton *secondChangeBtn = [UIButton new];
    [secondChangeBtn setImage:SYImageNamed(@"home_btn_close") forState:UIControlStateNormal];
    _secondChangeBtn = secondChangeBtn;
    [secondAnchorView addSubview:secondChangeBtn];
    
    UIView *secondBgView = [UIView new];
    secondBgView.backgroundColor = SYColorAlpha(0, 0, 0, 0.5);
    _secondBgView = secondBgView;
    [secondAnchorView addSubview:secondBgView];
    
    UILabel *secondHobbyLabel = [UILabel new];
    secondHobbyLabel.textColor = [UIColor whiteColor];
    secondHobbyLabel.textAlignment = NSTextAlignmentLeft;
    secondHobbyLabel.font =SYRegularFont(11);
    _secondHobbyLabel = secondHobbyLabel;
    [secondBgView addSubview:secondHobbyLabel];
    
    UILabel *secondPriceLabel = [UILabel new];
    secondPriceLabel.textColor = [UIColor whiteColor];
    secondPriceLabel.textAlignment = NSTextAlignmentLeft;
    secondPriceLabel.font =SYRegularFont(11);
    _secondPriceLabel = secondPriceLabel;
    [secondAnchorView addSubview:secondPriceLabel];

    UIImageView *thirdAnchorView = [UIImageView new];
    thirdAnchorView.layer.masksToBounds = YES;
    thirdAnchorView.layer.cornerRadius = 5.f;
    thirdAnchorView.userInteractionEnabled = YES;
    _thirdAnchorView = thirdAnchorView;
    [bgView addSubview:thirdAnchorView];
    
    UIButton *thirdChangeBtn = [UIButton new];
    [thirdChangeBtn setImage:SYImageNamed(@"home_btn_close") forState:UIControlStateNormal];
    _thirdChangeBtn = thirdChangeBtn;
    [thirdAnchorView addSubview:thirdChangeBtn];
    
    UIView *thirdBgView = [UIView new];
    thirdBgView.backgroundColor = SYColorAlpha(0, 0, 0, 0.5);
    _thirdBgView = thirdBgView;
    [thirdAnchorView addSubview:thirdBgView];
    
    UILabel *thirdHobbyLabel = [UILabel new];
    thirdHobbyLabel.textColor = [UIColor whiteColor];
    thirdHobbyLabel.textAlignment = NSTextAlignmentLeft;
    thirdHobbyLabel.font =SYRegularFont(11);
    _thirdHobbyLabel = thirdHobbyLabel;
    [thirdBgView addSubview:thirdHobbyLabel];
    
    UILabel *thirdPriceLabel = [UILabel new];
    thirdPriceLabel.textColor = [UIColor whiteColor];
    thirdPriceLabel.textAlignment = NSTextAlignmentLeft;
    thirdPriceLabel.font =SYRegularFont(11);
    _thirdPriceLabel = thirdPriceLabel;
    [thirdAnchorView addSubview:thirdPriceLabel];
    
    UIButton *randomBtn = [UIButton new];
    [randomBtn setImage:SYImageNamed(@"home_btn_change") forState:UIControlStateNormal];
    _randomBtn = randomBtn;
    [bgView addSubview:randomBtn];
}

- (void)_makeSubViewsConstraints {
    CGFloat width = (SY_SCREEN_WIDTH - 15 * 4) / 3;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.width.height.offset(120);
        make.top.equalTo(self.bgView).offset(15);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.width.offset(150);
        make.height.offset(20);
        make.top.equalTo(self.headImageView.mas_bottom).offset(15);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.titleLabel);
        make.height.offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    [self.onlineAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.left.equalTo(self.bgView).offset(15);
        make.height.offset(15);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(45);
    }];
    [self.firstAnchorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.onlineAmountLabel.mas_bottom).offset(15);
        make.width.offset(width);
        make.height.offset(1.43 * width);
    }];
    [self.firstChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.top.equalTo(self.firstAnchorView).offset(5);
        make.right.equalTo(self.firstAnchorView).offset(-5);
    }];
    [self.firstBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.firstAnchorView);
        make.height.offset(30);
    }];
    [self.firstHobbyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.firstBgView);
        make.height.offset(15);
    }];
    [self.firstPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.firstBgView);
        make.height.offset(15);
    }];
    [self.secondAnchorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstAnchorView.mas_right).offset(15);
        make.top.width.height.equalTo(self.firstAnchorView);
    }];
    [self.secondChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.top.equalTo(self.secondAnchorView).offset(5);
        make.right.equalTo(self.secondAnchorView).offset(-5);
    }];
    [self.secondBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.secondAnchorView);
        make.height.offset(30);
    }];
    [self.secondHobbyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.secondBgView);
        make.height.offset(15);
    }];
    [self.secondPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.secondBgView);
        make.height.offset(15);
    }];
    [self.thirdAnchorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondAnchorView.mas_right).offset(15);
        make.top.width.height.equalTo(self.firstAnchorView);
    }];
    [self.thirdChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.top.equalTo(self.thirdAnchorView).offset(5);
        make.right.equalTo(self.thirdAnchorView).offset(-5);
    }];
    [self.thirdBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.thirdAnchorView);
        make.height.offset(30);
    }];
    [self.thirdHobbyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.thirdBgView);
        make.height.offset(15);
    }];
    [self.thirdPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.thirdBgView);
        make.height.offset(15);
    }];
    [self.randomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstAnchorView.mas_bottom).offset(30);
        make.centerX.equalTo(self.bgView);
        make.width.offset(90);
        make.height.offset(30);
    }];
}

// 多视频循环播放
- (void)playVideo:(NSString *)url andIndex:(int)index {
    @weakify(self)
    [[SYListVideoPlayer sharedPlayer] startPlayVideo:url withVideoDecode:^(CGImageRef videoImageRef, NSString *videoFilePath) {
        @strongify(self)
        if (index == 0) {
            self.firstAnchorView.layer.contents = (__bridge id _Nullable)(videoImageRef);
        } else if (index == 1) {
            self.secondAnchorView.layer.contents = (__bridge id _Nullable)(videoImageRef);
        } else {
            self.thirdAnchorView.layer.contents = (__bridge id _Nullable)(videoImageRef);
        }
    }];
    
    [[SYListVideoPlayer sharedPlayer] reloadVideoPlay:^(NSString *videoFilePath) {
        [self playVideo:videoFilePath andIndex:index];
    } withFilePath:url];
}

// 开启摄像头采集人脸
- (void)collectHeadImage {
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    vision.cameraMode = PBJCameraModePhoto;
    vision.cameraOrientation = PBJCameraOrientationPortrait;
    vision.focusMode = PBJFocusModeContinuousAutoFocus;
    vision.outputFormat = PBJOutputFormatSquare;
    vision.cameraDevice = PBJCameraDeviceFront;
    [vision startPreview];
}

// 随机抽取3名主播
- (void) randomSelectAnchors {
    NSMutableSet *anchorsSet = [NSMutableSet new];
    while ([anchorsSet count] < 3) {
        int i = arc4random() % [self.viewModel.datasource count];
        [anchorsSet addObject:@(i)];
        NSNumber *oldValue = self.anchorsIndexArray[[anchorsSet count] - 1];
        if ([oldValue intValue] == i) {
            [anchorsSet removeObject:@(i)];
        }
    }
    self.anchorsIndexArray = [anchorsSet allObjects];
}

- (NSString *)returnFilePathByUrl:(NSString *) url {
    CocoaSecurityResult *result = [CocoaSecurity md5:url];
    return [NSString stringWithFormat:@"%@/chooseVideo_%@.mp4",SYSeeYuCacheDirPath(),result.hexLower];
}

@end
