//
//  YLVideoPreView.m
//  NHZGame
//
//  Created by MH on 2017/6/27.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import "YLVideoPreView.h"
#import <AVFoundation/AVFoundation.h>
@interface YLVideoPreView ()
{
    UIButton * _cancleBtn;
    UIButton * _sureBtn;
}
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVURLAsset *urlAsset;
@property (nonatomic, strong) AVPlayerLayer*playerLayer;

@end

@implementation YLVideoPreView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        //取消按钮
        _cancleBtn = [UIButton buttonWithType:0];
        [_cancleBtn setImage:[UIImage imageNamed:@"cha"] forState:0];
        [_cancleBtn addTarget:self action:@selector(cancleItemSelected) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancleBtn];
        _cancleBtn.sd_layout.leftSpaceToView(self, 60).bottomSpaceToView(self, 70).widthIs(65).heightEqualToWidth();
        
        //确认按钮
        _sureBtn = [UIButton buttonWithType:0];
        [_sureBtn setImage:[UIImage imageNamed:@"hao"] forState:0];
        [_sureBtn addTarget:self action:@selector(sureItemClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
        _sureBtn.sd_layout.rightSpaceToView(self, 60).bottomSpaceToView(self, 70).widthIs(65).heightEqualToWidth();
    }
    return self;
}
-(void)cancleItemSelected
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ylVideoPreViewitemBack:)]) {
        [self.delegate ylVideoPreViewitemBack:NO];
    }
}
-(void)sureItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ylVideoPreViewitemBack:)]) {
        [self.delegate ylVideoPreViewitemBack:YES];
    }
}
-(void)preViewClear
{
    if (self.player) {
        [_player pause];
    }
    if (self.playerLayer) {
        // 移除原来的layer
        [self.playerLayer removeFromSuperlayer];
    }
    if (self.player) {
        // 替换PlayerItem为nil
        [self.player replaceCurrentItemWithPlayerItem:nil];
    }
}
-(void)setitemCanUse:(BOOL)canuse
{
    _cancleBtn.enabled = canuse;
    _sureBtn.enabled = canuse;
}
-(void)setVideoUrl:(NSURL *)videoUrl
{
    self.urlAsset = [AVURLAsset assetWithURL:videoUrl];
    // 初始化playerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    //    self.player.volume = 0;
    // 初始化playerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.bounds;
    //此处设置视频填充模式为默认
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:self.playerLayer];
    [self bringSubviewToFront:_cancleBtn];
    [self bringSubviewToFront:_sureBtn];
    [self.player play];
}
@end
