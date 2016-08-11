//
//  RecordAudioViewController.m
//  TCAVIMDemo
//
//  Created by AlexiChen on 16/8/8.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//
#if kIsInnerTest
#import "RecordAudioViewController.h"

@interface  RecordAudioVC: UserAppBaseUIViewController
{
@protected
    UIButton *_audioRecordButton;
    UIButton *_videoRecordButton;
    
}

@end


@implementation RecordAudioVC

- (void)addOwnViews
{
    [super addOwnViews];
    
    _audioRecordButton = [[UIButton alloc] init];
    [_audioRecordButton setTitle:@"音频" forState:UIControlStateNormal];
    [_audioRecordButton setTitle:@"停止" forState:UIControlStateSelected];
    _audioRecordButton.backgroundColor = [kLightGrayColor colorWithAlphaComponent:0.5];
    [_audioRecordButton addTarget:self action:@selector(onRecordAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_audioRecordButton];
    
    _videoRecordButton = [[UIButton alloc] init];
    [_videoRecordButton setTitle:@"视频" forState:UIControlStateNormal];
    [_videoRecordButton setTitle:@"停止" forState:UIControlStateSelected];
    _videoRecordButton.backgroundColor = [kLightGrayColor colorWithAlphaComponent:0.5];
    [_videoRecordButton addTarget:self action:@selector(onRecordVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_videoRecordButton];
}


- (void)layoutOnIPhone
{
    [super layoutOnIPhone];
    
    [_audioRecordButton sameWith:_closeUI];
    [_audioRecordButton layoutToLeftOf:_closeUI margin:kDefaultMargin];
    
    [_videoRecordButton sameWith:_audioRecordButton];
    [_videoRecordButton layoutToLeftOf:_audioRecordButton margin:kDefaultMargin];
}

- (void)onRecordAudio:(UIButton *)btn
{
    TCAVLiveRoomEngine *engine = (TCAVLiveRoomEngine *)_roomEngine;
    NSString *tag = @"8921";
    AVRecordInfo *avRecordinfo = [[AVRecordInfo alloc] init];
    avRecordinfo.fileName = [[engine getRoomInfo] liveTitle];
    avRecordinfo.tags = @[tag];
    avRecordinfo.classId = [tag intValue];
    avRecordinfo.isTransCode = NO;
    avRecordinfo.isScreenShot = NO;
    avRecordinfo.isWaterMark = NO;
    avRecordinfo.recordType = AV_RECORD_TYPE_AUDIO;
    if (!btn.selected)
    {
        btn.enabled = NO;
        [engine asyncStartRecord:avRecordinfo completion:^(BOOL succ, TCAVLiveRoomRecordRequest *req) {
            DebugLog(@"开始音频录制成功");
            btn.enabled = YES;
            btn.selected = !btn.selected;
        }];
    }
    else
    {
        btn.enabled = NO;
        [engine asyncStartRecord:avRecordinfo completion:^(BOOL succ, TCAVLiveRoomRecordRequest *req) {
            DebugLog(@"开始音频录制成功");
            btn.enabled = YES;
            btn.selected = !btn.selected;
        }];
    }

}

- (void)onRecordVideo:(UIButton *)btn
{
    TCAVLiveRoomEngine *engine = (TCAVLiveRoomEngine *)_roomEngine;
    NSString *tag = @"8921";
    AVRecordInfo *avRecordinfo = [[AVRecordInfo alloc] init];
    avRecordinfo.fileName = [[engine getRoomInfo] liveTitle];
    avRecordinfo.tags = @[tag];
    avRecordinfo.classId = [tag intValue];
    avRecordinfo.isTransCode = NO;
    avRecordinfo.isScreenShot = NO;
    avRecordinfo.isWaterMark = NO;
    avRecordinfo.recordType = AV_RECORD_TYPE_VIDEO;
    if (!btn.selected)
    {
        btn.enabled = NO;
        [engine asyncStartRecord:avRecordinfo completion:^(BOOL succ, TCAVLiveRoomRecordRequest *req) {
            DebugLog(@"开始音频录制成功");
            btn.enabled = YES;
            btn.selected = !btn.selected;
        }];
    }
    else
    {
        btn.enabled = NO;
        [engine asyncStartRecord:avRecordinfo completion:^(BOOL succ, TCAVLiveRoomRecordRequest *req) {
            DebugLog(@"开始音频录制成功");
            btn.enabled = YES;
            btn.selected = !btn.selected;
        }];
    }
    
}

@end


@implementation RecordAudioViewController

- (void)addLiveView
{
    // 子类重写
    RecordAudioVC *uivc = [[RecordAudioVC alloc] initWith:self];
    [self addChild:uivc inRect:self.view.bounds];
    
    _liveView = uivc;
}


@end
#endif