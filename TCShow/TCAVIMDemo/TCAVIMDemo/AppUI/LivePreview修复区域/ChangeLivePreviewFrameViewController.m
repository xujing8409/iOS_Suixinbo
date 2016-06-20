//
//  ChangeLivePreviewFrameViewController.m
//  TCAVIMDemo
//
//  Created by AlexiChen on 16/6/20.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChangeLivePreviewFrameViewController.h"


@interface  ChangeLivePreviewFrameVC: UserAppBaseUIViewController
{
@protected
    UIButton *_scaleButton;
    
}

@end


@implementation ChangeLivePreviewFrameVC

- (void)addOwnViews
{
    [super addOwnViews];
    
    _scaleButton = [[UIButton alloc] init];
    [_scaleButton setTitle:@"缩小" forState:UIControlStateNormal];
    [_scaleButton setTitle:@"全屏" forState:UIControlStateSelected];
    _scaleButton.backgroundColor = [kLightGrayColor colorWithAlphaComponent:0.5];
    [_scaleButton addTarget:self action:@selector(onScale:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scaleButton];
}


- (void)layoutOnIPhone
{
    [super layoutOnIPhone];
    
    [_scaleButton sameWith:_closeUI];
    [_scaleButton layoutToLeftOf:_closeUI margin:kDefaultMargin];
}

- (void)onScale:(UIButton *)btn
{
    ChangeLivePreviewFrameViewController *vc = (ChangeLivePreviewFrameViewController *)_liveController;
    btn.selected = !btn.selected;
    [vc changeToSmallScreen:btn.selected];
}

@end


@interface ChangeLivePreviewFrameViewController ()

@end

@implementation ChangeLivePreviewFrameViewController

- (void)addLiveView
{
    // 子类重写
    UserAppBaseUIViewController *uivc = [[ChangeLivePreviewFrameVC alloc] initWith:self];
    [self addChild:uivc inRect:self.view.bounds];
    
    _liveView = uivc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
}

- (void)changeToSmallScreen:(BOOL)isSamll
{
    id<AVMultiUserAble> livehost = (id<AVMultiUserAble>)[_roomInfo liveHost];
    
    if (isSamll)
    {
        CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, 240);
        rect = CGRectInset(rect, (rect.size.width - 160)/2, (rect.size.height - 240)/2);
        [self changeRender:livehost toFrame:rect fullScreen:!isSamll];
    }
    else
    {
        [self changeRender:livehost toFrame:self.view.bounds fullScreen:!isSamll];
    }
    
}

- (void)changeRender:(id<AVMultiUserAble>)user toFrame:(CGRect)rect fullScreen:(BOOL)fullScreen
{
    AVGLRenderView *view = [_livePreview.imageView getSubviewForKey:[user imUserId]];
    if (view)
    {
        if (fullScreen)
        {
            view.frame = _livePreview.imageView.bounds;
        }
        else
        {
            view.frame = rect;
        }
    }
    else
    {
        DebugLog(@"无对应[%@]的renderview", [user imUserId]);
    }
    
}
@end
