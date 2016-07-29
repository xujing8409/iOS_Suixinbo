//
//  LiveUIViewController.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "LiveUIViewController.h"

@implementation LiveUIViewController

- (void)addOwnViews
{
    id<AVRoomAble> room = [_liveController roomInfo];
    _liveView = [[LiveUIView alloc] initWith:(id<AVRoomAble>)room];
    _liveView.topView.delegate = self;
    [self.view addSubview:_liveView];
}

- (void)layoutOnIPhone
{
    [_liveView setFrameAndLayout:self.view.bounds];
}

#pragma mark - LiveUITopViewDelegate
- (void)onTopViewCloseLive:(LiveUITopView *)topView
{
    [_liveController alertExitLive];
}

#pragma mark - AVIMMsgListener
// 收到群聊天消息: (主要是文本类型)
- (void)onIMHandler:(AVIMMsgHandler *)receiver recvGroupMsg:(id<AVIMMsgAble>)msg
{
    [_liveView.msgView insertMsg:msg];
}

- (void)setMsgHandler:(TCSoMsgHandler *)msgHandler
{
    msgHandler.roomIMListner = self;
    [_liveView.bottomView setMsgHandler:msgHandler];
    _msgHandler = msgHandler;

}

#if kSupportIMMsgCache

- (void)onUIRefreshIMMsg:(AVIMCache *)cache
{
    [_liveView.msgView insertCachedMsg:cache];
}

- (void)onUIRefreshPraise:(AVIMCache *)cache
{
    [_liveView onRecvPraise:cache];
}

- (void)onUIRefreshFlower:(AVIMCache *)cache
{
    [_liveView onRecvFlower:cache];
}

#endif

- (void)uiStartLive
{
    [_liveView startLive];
}

- (void)setRoomEngine:(TCAVBaseRoomEngine *)roomEngine
{
    _roomEngine = roomEngine;
    [_liveView setRoomEngine:(TCAVLiveRoomEngine *)roomEngine];
}

- (void)onIMHandler:(AVIMMsgHandler *)receiver recvCustomGroup:(id<AVIMMsgAble>)msg
{
    DebugLog(@"onIMHandler");
    switch ([msg msgType])
    {
        case AVIMCMD_Praise:
        {
            [_liveView onRecvPraise];
            
        }
            break;
        case TCSoAVIMCommand_Flower:
        {
            DebugLog(@"recv flower");
            [_liveView onRecvFlower];
        }
            break;
//        case AVIMCMD_Host_Leave:
//        {
//            [self onRecvCustomLeave:msg];
//        }
//            break;
//        case AVIMCMD_Host_Back:
//        {
//            [self onRecvCustomBack:msg];
//            
//        }
//            break;
        default:
            break;
    }
}
@end
