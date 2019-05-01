//
//  YLShortVideoVC.m
//  NHZGame
//
//  Created by MH on 2017/6/27.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import "YLShortVideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MHAssetPickerViewController.h"
#import "VideoEditingView.h"//视频处理菊花
#import "YLVideoPreView.h"//视频预览view
#import "MHGetPermission.h"//权限

#define kMaxVideoLength 15
#define kProgressTimerTimeInterval 0.015
// 视频URL路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

@interface YLShortVideoVC ()<AVCaptureFileOutputRecordingDelegate, UIGestureRecognizerDelegate,MHAssetPickerControllerDelegate,UINavigationControllerDelegate,YLVideoPreViewDelegate>

@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;//视频输出流
@property(nonatomic,assign)BOOL canShort;//摄像头是否可用
@property(nonatomic,assign)BOOL canAudioUse;//麦克风是否可用
@property (strong, nonatomic) UIButton *takeButton;//拍照按钮
@property (nonatomic, strong) CAShapeLayer *btnOutLayer;//开始录制按钮 外框
@property (nonatomic, strong) CAShapeLayer *progressLayer;//录制按钮 圆环进度
@property (strong, nonatomic) UIButton *chooseLib;//从相册选择
@property (strong, nonatomic) UIButton *changeSXTBtn;//切换前后摄像头按钮
@property (strong, nonatomic) UIButton *goBackBtn;//返回按钮
@property (nonatomic, strong) NSTimer *progressTimer;//录制定时器
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;//后台任务标识
@property (nonatomic, assign) CGFloat videoLength;//视频录制时长
@property(nonatomic,copy)NSURL * curentVideoUrl;//未处理的视频的地址
@property(nonatomic,copy)NSURL * videoUrl;//最终视频的地址
/*拍摄完 或 选择之后 视频预览*/
@property(nonatomic,strong)YLVideoPreView * playerPreView;//视频预览view

@property(nonatomic,assign)BOOL isFirstTime;//是否是第一次进入该vc

@end

@implementation YLShortVideoVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_isFirstTime) {//第一次进入后，先判断用户权限，再创建界面
        _isFirstTime = NO;
        [self makeSureUserAuth];
    }else{
        if (_canShort) {
            [self.captureSession startRunning];
        }
    }
    [UIApplication sharedApplication].statusBarHidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    if (_canShort) {
        [self.captureSession stopRunning];
    }
    [self.playerPreView preViewClear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _isFirstTime = YES;
}
#pragma mark - 检测用户权限
-(void)makeSureUserAuth
{
    [MHGetPermission getCaptureDevicePermission:^(BOOL has) {
        if (has) {
            [MHGetPermission getAudioRecordPermission:^(BOOL has) {
                if (!has) {
                    NSLog(@"-----没有麦克风权限--------");
                }else{
                    _canAudioUse = YES;
                }
                [self setupCaptureSession];
                [self setupView];
            }];
        }else{
            NSLog(@"没有摄像头权限");
            [self setupView];
        }
    }];
}
#pragma mark - 初始化摄像头 预览图层
-(void)setupCaptureSession
{
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
    }
    //获得摄像头输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        _canShort = NO;
        return;
    }
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        _canShort = NO;
        return;
    }
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    if (_canAudioUse) {//音频设备输入
        //添加一个音频输入设备
        AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        AVCaptureDeviceInput *audioCaptureDeviceInput=[AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
        if (error) {
            NSLog(@"麦克风设备出错：%@",error.localizedDescription);
        }
        if ([_captureSession canAddInput:audioCaptureDeviceInput]) {
            [_captureSession addInput:audioCaptureDeviceInput];
        }
    }
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    _canShort = YES;
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    CALayer *layer=self.view.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式AVLayerVideoGravityResizeAspectFill
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
    [self.captureSession startRunning];
}
#pragma mark - 初始化各种按钮 view
-(void)setupView
{
    //拍摄按钮
    self.takeButton = [UIButton buttonWithType:0];
    self.takeButton.backgroundColor = [UIColor whiteColor];
    [self.takeButton addTarget:self action:@selector(startRecordingVideo) forControlEvents:UIControlEventTouchDown];
    [self.takeButton addTarget:self action:@selector(endRecordingVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.takeButton addTarget:self action:@selector(endRecordingVideo) forControlEvents:UIControlEventTouchUpOutside];
    self.takeButton.enabled = _canShort && _canAudioUse;
    [self.view addSubview:self.takeButton];
    self.takeButton.sd_layout.centerXEqualToView(self.view).centerYIs(Screen_HEIGTH-Width(95)).widthIs(Width(80)).heightEqualToWidth();
    self.takeButton.sd_cornerRadiusFromWidthRatio = @(0.5);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Width(40), Width(40)) radius:Width(40) startAngle:-M_PI_2 endAngle:-M_PI_2 +M_PI*2 clockwise:YES];
    self.btnOutLayer = [CAShapeLayer layer];
    self.btnOutLayer.strokeColor = HexRGBAlpha(0xc8c8c8, 1).CGColor;
    self.btnOutLayer.lineWidth = Width(30);
    self.btnOutLayer.fillColor =  [UIColor clearColor].CGColor;
    self.btnOutLayer.lineCap = kCALineCapRound;
    self.btnOutLayer.path = path.CGPath;
    [self.takeButton.layer addSublayer:self.btnOutLayer];
    
    //返回按钮
    self.goBackBtn = [UIButton buttonWithType:0];
    [self.goBackBtn setImage:[UIImage imageNamed:@"short_back"] forState:0];
    [self.goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goBackBtn];
    self.goBackBtn.sd_layout.centerXIs(Screen_WIDTH/2-Width(90)-Width(25)).centerYEqualToView(self.takeButton).widthIs(Width(30)).heightIs(Width(20));
    
    //切换摄像头按钮
    self.changeSXTBtn = [UIButton buttonWithType:0];//48*40
    [self.changeSXTBtn setImage:[UIImage imageNamed:@"icon_reverse"] forState:0];
    self.changeSXTBtn.enabled = _canShort && _canAudioUse;;
    [self.changeSXTBtn addTarget:self action:@selector(toggleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeSXTBtn];
    self.changeSXTBtn.sd_layout.rightSpaceToView(self.view, 20).widthIs(Width(30)).heightIs(Width(25)).topSpaceToView(self.view, 30);
    
    //相册选择按钮
    self.chooseLib = [UIButton buttonWithType:0];
    [self.chooseLib setImage:[UIImage imageNamed:@"btn_pic"] forState:0];
    [self.chooseLib addTarget:self action:@selector(chooseFromXIngce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chooseLib];
    self.chooseLib.sd_layout.centerXIs(Screen_WIDTH/2 + Width(90)+Width(25)).centerYEqualToView(self.takeButton).widthIs(Width(30)).heightIs(22);
    
    //视频预览view
    self.playerPreView = [[YLVideoPreView alloc] init];
    self.playerPreView.hidden = YES;
    self.playerPreView.delegate = self;
    [self.view addSubview:self.playerPreView];
    self.playerPreView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
}
#pragma mark - 显示视频预览
-(void)showPlayerPreview:(NSURL *)videoUrl
{
    self.curentVideoUrl = videoUrl;
    //停止session 显示预览
    [self.captureSession stopRunning];
    self.playerPreView.hidden = NO;
    [self.playerPreView setVideoUrl:videoUrl];
}
#pragma makr- 是否选择该视频
-(void)ylVideoPreViewitemBack:(BOOL)sure
{
    if (sure) {
        [VideoEditingView showVideoEditing];
        [self.playerPreView setitemCanUse:NO];
        
        [VideoEditingView lowQuailtyWithInputURL:self.curentVideoUrl blockHandler:^(BOOL success, AVAssetExportSession *session, NSURL *compressionVideoURL) {
            if (success) {
                NSData *data = [NSData dataWithContentsOfURL:compressionVideoURL];
                float memorySize = (float)data.length / 1024 / 1024;
                NSLog(@"视频压缩后大小 %f", memorySize);
                self.videoUrl = compressionVideoURL;
                [VideoEditingView endVideoEditIng];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self goBack];
                    [self.playerPreView setitemCanUse:YES];
                });
            }else{
                [VideoEditingView endVideoEditIng];
                [self.playerPreView setitemCanUse:YES];
                NSLog(@"视频处理失败，请稍后再试...");
            }
            
        }];
    }else{
        [self.playerPreView preViewClear];
        self.curentVideoUrl = nil;
        //开启session 禁用/启用按钮
        [self.captureSession startRunning];
        self.playerPreView.hidden = YES;
    }
}
#pragma mark - 定时器 相关
- (void)setupTimer
{
    self.videoUrl = nil;//当开始录制时 将路径置为nil
    self.goBackBtn.enabled = NO;
    self.changeSXTBtn.enabled = NO;
    self.chooseLib.enabled = NO;
    self.takeButton.sd_resetLayout.centerXEqualToView(self.view).centerYIs(Screen_HEIGTH-Width(95)).widthIs(Width(120)).heightEqualToWidth();
    self.goBackBtn.sd_resetLayout.centerXIs(Screen_WIDTH/2-Width(90)-Width(25)).centerYEqualToView(self.takeButton).widthIs(Width(30)).heightIs(Width(20));
    self.chooseLib.sd_resetLayout.centerXIs(Screen_WIDTH/2 + Width(90)+Width(25)).centerYEqualToView(self.takeButton).widthIs(Width(30)).heightIs(22);
    
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.3];
    UIBezierPath *outPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Width(60), Width(60)) radius:Width(60) startAngle:-M_PI_2 endAngle:-M_PI_2 +M_PI*2 clockwise:YES];
    self.btnOutLayer.lineWidth = Width(80);
    self.btnOutLayer.path = outPath.CGPath;
    [CATransaction commit];
    
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = CGRectMake(0, 0, Width(120), Width(120));
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _progressLayer.strokeColor = [HexRGBAlpha(0x4fb530, 1) CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapButt;
    _progressLayer.lineWidth = Width(16);//线的宽度
    _progressLayer.strokeEnd =  0.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Width(60), Width(60)) radius:Width(60) startAngle:-M_PI_2 endAngle:-M_PI_2+M_PI*2 clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path =[path CGPath];
    [_takeButton.layer addSublayer:_progressLayer];
    
    self.videoLength = 0;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:kProgressTimerTimeInterval target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}
- (void)removeTimer
{
    self.goBackBtn.enabled = YES;
    self.changeSXTBtn.enabled = YES;
    self.chooseLib.enabled = YES;
    self.takeButton.sd_resetLayout.centerXEqualToView(self.view).centerYIs(Screen_HEIGTH-Width(95)).widthIs(Width(80)).heightEqualToWidth();
    self.goBackBtn.sd_resetLayout.centerXIs(Screen_WIDTH/2-Width(90)-Width(25)).centerYEqualToView(self.takeButton).widthIs(Width(30)).heightIs(22);
    self.chooseLib.sd_resetLayout.centerXIs(Screen_WIDTH/2 + Width(90)+Width(25)).centerYEqualToView(self.takeButton).widthIs(Width(30)).heightIs(22);
    
    [_progressLayer removeFromSuperlayer];
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.3];
    UIBezierPath *outPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Width(40), Width(40)) radius:Width(40) startAngle:-M_PI_2 endAngle:-M_PI_2 +M_PI*2 clockwise:YES];
    self.btnOutLayer.lineWidth = Width(30);
    self.btnOutLayer.path = outPath.CGPath;
    [CATransaction commit];
    
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}
- (void)updateProgress
{
    if (self.videoLength >= kMaxVideoLength) {
        [self removeTimer];
        [self endRecordingVideo];
        return;
    }
    self.videoLength += kProgressTimerTimeInterval;
    CGFloat progress = self.videoLength / kMaxVideoLength;
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:kProgressTimerTimeInterval];
    self.progressLayer.strokeEnd =  progress;
    [CATransaction commit];
}
#pragma mark - 开始录制
-(void)startRecordingVideo
{
    [self setupTimer];
    
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if (![self.captureMovieFileOutput isRecording]) {
        //如果支持多任务则则开始多任务
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            self.backgroundTaskIdentifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
        NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
        NSLog(@"save path is :%@",outputFielPath);
        NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
        [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }
}
#pragma mark - 结束录制
-(void)endRecordingVideo
{
    [self removeTimer];
    if ([self.captureMovieFileOutput isRecording]) {
        [self.captureMovieFileOutput stopRecording];//停止录制
    }
}
#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
}
#pragma mark - 录制结束
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"视频录制完成. path=%@",outputFileURL);
    if (self.videoLength >= 3) {
        //显示预览及取消和确认按钮
        [self showPlayerPreview:outputFileURL];
        //视频录入完成之后在后台将视频存储到相簿
        UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier=self.backgroundTaskIdentifier;
        self.backgroundTaskIdentifier=UIBackgroundTaskInvalid;
        ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
            }else{
                NSLog(@"成功保存视频到相簿.");
            }
            if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
            }
        }];
    }
}
#pragma mark 切换前后摄像头
-(void)toggleButtonClick {
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[AVCaptureDeviceInput deviceInputWithDevice:toChangeDevice error:nil];
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput=toChangeDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
}
#pragma mark - 获取指定方向的摄像头
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}
#pragma mark - 相册选择
-(void)chooseFromXIngce
{
    [MHGetPermission getPhotosPermission:^(BOOL has) {
        if (has) {
            MHAssetPickerViewController *picker = [[MHAssetPickerViewController alloc] init];
            picker.assetPickType = MHAssetPickTypeVideo;
            picker.delegate=self;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 3 && duration <= 30;
                } else {
                    return YES;
                }
            }];
            [UIApplication sharedApplication].statusBarHidden = NO;
            [self presentViewController:picker animated:YES completion:^{
            }];
        }else{
            //无权限
        }
    }];
    
}
#pragma mark - 选图代理
-(void)assetPickerController:(MHAssetPickerViewController *)picker didFinishPickingVideo:(NSURL *)videoUrl
{
    //显示预览及取消和确认按钮
    [self showPlayerPreview:videoUrl];
    //
    //    self.videoUrl = videoUrl;
    //    self.shortVideoBack(self.videoUrl);
    //    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 退出界面
-(void)goBack
{
    if (self.videoUrl) {
        self.shortVideoBack(self.videoUrl);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
