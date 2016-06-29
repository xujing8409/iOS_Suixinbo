//
//  TCAVLivePreview.h
//  TCShow
//
//  Created by AlexiChen on 15/11/16.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

// 主播端的渲染
// TCAVLivePreview 处理一路画面显示的问题
@interface TCAVLivePreview : UIView
{
@protected
    AVGLBaseView                *_imageView;            // 画面
    TCAVFrameDispatcher         *_frameDispatcher;      // 分发器
@protected
}

@property (nonatomic, readonly) AVGLBaseView *imageView;

// user为该画面对应的对象
// 默认全屏显示, 本地只有路画面
- (void)addRenderFor:(id<IMUserAble>)user;

- (void)updateRenderFor:(id<AVMultiUserAble>)user;

- (void)removeRenderOf:(id<IMUserAble>)user;

- (void)render:(QAVVideoFrame *)frame mirrorReverse:(BOOL)reverse fullScreen:(BOOL)fullShow;

// 开始预览
- (void)startPreview;

- (void)stopPreview;

- (void)stopAndRemoveAllRender;


@end
