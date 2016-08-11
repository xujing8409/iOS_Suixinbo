//
//  LiveViewController.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "LiveViewController.h"

@implementation LiveViewController

//添加交互界面
- (void)addLiveView
{
    LiveUIViewController *liveUI = [[LiveUIViewController alloc] initWith:self];
    [self addChild:liveUI inRect:self.view.bounds];
    
    _liveView = liveUI;
}

- (void)createRoomEngine
{
    if (!_roomEngine)
    {
        
        id<AVUserAble> ah = (id<AVUserAble>)_currentUser;
        [ah setAvCtrlState:[self defaultAVHostConfig]];
        TCSoLiveRoomEngine *roomEngine = [[TCSoLiveRoomEngine alloc] initWith:(id<IMHostAble, AVUserAble>)_currentUser enableChat:_enableIM];
        // 测试默认开启后置摄像头
        // roomEngine.cameraId = CameraPosBack;
        roomEngine.delegate = self;
        _roomEngine = roomEngine;
        
        if (!_isHost)
        {
            [_liveView setRoomEngine:_roomEngine];
        }
    }
}

- (NSInteger)defaultAVHostConfig
{
    
    // 添加推荐配置
    if (_isHost)
    {
        return EAVCtrlState_Mic | EAVCtrlState_Speaker | EAVCtrlState_Camera;
    }
    else
    {
        return EAVCtrlState_Speaker;
    }
}


- (void)onAVEngine:(TCAVBaseRoomEngine *)engine users:(NSArray *)users exitRoom:(id<AVRoomAble>)room
{
    // 此处，根据具体业务来处理：比如的业务下，支持主播可以退出再进，这样观众可以在线等待就不用退出了
    NSString *roomHostId = [[room liveHost] imUserId];
    for (id<IMUserAble> iu in users)
    {
        if ([[iu imUserId] isEqualToString:roomHostId])
        {
            if (!self.isExiting)
            {
                [self willExitLiving];
                // 说明主播退出
                UIAlertView *alert =  [UIAlertView bk_showAlertViewWithTitle:nil message:@"主播已退出当前直播" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [self exitLive];
                }];
                [alert show];
                break;
            }
        }
    }
}


- (void)prepareIMMsgHandler
{
    if (!_msgHandler)
    {
        _msgHandler = [[TCSoMsgHandler alloc] initWith:_roomInfo];
        _liveView.msgHandler = (TCSoMsgHandler *)_msgHandler;
        [_msgHandler enterLiveChatRoom:nil fail:nil];
    }
    else 
    {
        __weak AVIMMsgHandler *wav = (AVIMMsgHandler *)_msgHandler;
        __weak id<AVRoomAble> wr = _roomInfo;
        [_msgHandler exitLiveChatRoom:^{
            [wav switchToLiveRoom:wr];
            [wav enterLiveChatRoom:nil fail:nil];
        } fail:^(int code, NSString *msg) {
            [wav switchToLiveRoom:wr];
            [wav enterLiveChatRoom:nil fail:nil];
        }];
    }
}
#if kSupportIMMsgCache

- (void)onAVEngine:(TCAVBaseRoomEngine *)engine videoFrame:(QAVVideoFrame *)frame
{

    [super onAVEngine:engine videoFrame:frame];
    
    [self renderUIByAVSDK];
}

- (void)onAVEngine:(TCAVBaseRoomEngine *)engine enableCamera:(BOOL)succ tipInfo:(NSString *)tip
{
    [super onAVEngine:engine enableCamera:succ tipInfo:tip];
    if (succ)
    {
        // 调用liveStart接口
        LiveUIViewController *vc = (LiveUIViewController *)_liveView;
        [vc uiStartLive];
    }
}

- (void)renderUIByAVSDK
{
    // AVSDK采集为20帧每秒 : 具体数值看云后台配置
    // 可通过此处的控制显示的频率
    _uiRefreshCount++;
    LiveUIViewController *vc = (LiveUIViewController *)_liveView;
    
    // 1秒更新点赞
    if (_uiRefreshCount % 40 == 0)
    {
        NSDictionary *dic = [(AVIMMsgHandler *)_msgHandler getMsgCache];
        
        AVIMCache *msgcache = dic[@(AVIMCMD_Text)];
        [vc onUIRefreshIMMsg:msgcache];
        
        AVIMCache *praisecache = dic[@(AVIMCMD_Praise)];
        [vc onUIRefreshPraise:praisecache];
        
        AVIMCache *flowercache = dic[@(TCSoMsgType_Flower)];
        [vc onUIRefreshFlower:flowercache];
    }
}
#endif


@end
