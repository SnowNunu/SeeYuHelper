//
//  YLVideoPreView.h
//  NHZGame
//
//  Created by MH on 2017/6/27.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"

@protocol YLVideoPreViewDelegate <NSObject>


/**
 是否选择当前预览视频
 @param sure sure
 */
-(void)ylVideoPreViewitemBack:(BOOL)sure;

@end

//视频预览view
@interface YLVideoPreView : UIView

@property(nonatomic,weak)id <YLVideoPreViewDelegate> delegate;

-(void)setVideoUrl:(NSURL *)videoUrl;//设置视频预览
-(void)setitemCanUse:(BOOL)canuse;//当显示loading时，按钮不可用
-(void)preViewClear;//清除预览图层
@end
