//
//  VAInteractMicViewController.m
//  TCSoLive
//
//  Created by wilderliao on 16/8/10.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "VAInteractMicViewController.h"

@implementation VAInteractMicViewController

- (void)addLiveView
{
    VAInteractMicUIViewController *liveUI = [[VAInteractMicUIViewController alloc] initWith:self];
    [self addChild:liveUI inRect:self.view.bounds];
    _liveView = liveUI;
}

//互邀上麦S_3:在渲染界面中创建房间引擎
- (void)createRoomEngine
{
    if (!_roomEngine)
    {
        id<AVMultiUserAble> ah = (id<AVMultiUserAble>)_currentUser;
        [ah setAvMultiUserState:_isHost ? AVMultiUser_Host : AVMultiUser_Guest];
        [ah setAvCtrlState:[self defaultAVHostConfig]];
        _roomEngine = [[TCSoVAInteractRoomEngine alloc] initWith:(id<IMHostAble, AVMultiUserAble>)_currentUser enableChat:_enableIM];
        _roomEngine.delegate = self;
    }
}

//互邀上麦S_4: 在渲染界面初始化消息句柄，并赋值给交互界面中定义的消息句柄
//这里记得给 _multiManager.msgHandler 赋值
- (void)prepareIMMsgHandler
{
    if (!_msgHandler)
    {
        _msgHandler = [[TCSoVAInteractMsgHandler alloc] initWith:_roomInfo];
        _liveView.msgHandler = (TCSoVAInteractMsgHandler *)_msgHandler;
        _multiManager.msgHandler = (MultiAVIMMsgHandler *)_msgHandler;
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


//互邀上麦S_5:实现user窗口回调，在此回调中，分配小窗口资源(在这个回调中设置小窗口视频在主屏中的位置)
- (void)onAVIMMIMManager:(TCAVIMMIManager *)mgr assignWindowResourceTo:(id<AVMultiUserAble>)user isInvite:(BOOL)inviteOrAuto
{
    [(ViewersAskMicUIViewController *)_liveView assignWindowResourceTo:user isInvite:inviteOrAuto];
}

@end


@implementation TCSoVAInteractRoomEngine

- (void)enterIMLiveChatRoom:(id<AVRoomAble>)room
{
#if kSupportTimeStatistics
    [self onWillEnterLive];
#endif
    
    __weak TCAVLiveRoomEngine *ws = self;
    __weak id<TCAVRoomEngineDelegate> wd = _delegate;
    __weak id<AVRoomAble> wr = room;
#if kSupportTimeStatistics
    __weak NSDate *wl = _logStartDate;
#endif
    BOOL isHost = [self isHostLive];
    [[IMAPlatform sharedInstance] asyncEnterAVChatRoomWithAVRoomID:room succ:^(id<AVRoomAble> room) {
#if kSupportTimeStatistics
        NSDate *date = [NSDate date];
        TCAVIMLog(@"%@ 从进房到进入IM聊天室（%@）: 开始进房时间:%@ 创建聊天室完成时间:%@ 总耗时 :%0.3f (s)", isHost ? @"主播" : @"观众", [room liveIMChatRoomId] , [kTCAVIMLogDateFormatter stringFromDate:wl], [kTCAVIMLogDateFormatter stringFromDate:date] , -[wl timeIntervalSinceDate:date]);
#endif
        [ws onRealEnterLive:room];
    } fail:^(int code, NSString *msg) {
        [wd onAVEngine:ws enterRoom:wr succ:NO tipInfo:isHost ? @"创建直播聊天室失败" : @"加入直播聊天室失败"];
    }];
}

- (NSString *)roomControlRole
{
    // Spear上配置对应的有用户角色与配置
    if ([self isHostLive])
    {
        // 主播进入直播间对应的角色名
        return @"LiveHost";
    }
    else
    {
        // 观从进入直播间对应的角色名
        return @"InteractGuest";
    }
}

- (NSString *)interactUserRole
{
    return @"InteractUser";
}

@end
