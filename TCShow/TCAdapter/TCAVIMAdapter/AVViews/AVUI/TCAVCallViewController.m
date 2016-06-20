//
//  TCAVCallViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/6/6.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//
#if kSupportCallScene
#import "TCAVCallViewController.h"

@implementation TCAVCallViewController

- (void)startEnterCallRoom
{
    [self checkAndEnterAVRoom];
}

- (BOOL)isImmediatelyEnterLive
{
    return NO;
}



- (NSInteger)defaultAVHostConfig
{
    if (_isVoice)
    {
        // 添加推荐配置
        return EAVCtrlState_Speaker | EAVCtrlState_Mic;
        
    }
    else
    {
        return EAVCtrlState_All;
    }
}

- (void)createRoomEngine
{
    if (!_roomEngine)
    {
        id<AVMultiUserAble> ah = (id<AVMultiUserAble>)_currentUser;
        [ah setAvMultiUserState:_isHost ? AVMultiUser_Host : AVMultiUser_Guest];
        [ah setAvCtrlState:[self defaultAVHostConfig]];
        
        _roomEngine = [[TCAVCallRoomEngine alloc] initWith:(id<IMHostAble, AVMultiUserAble>)_currentUser enableChat:_enableIM];
        _roomEngine.delegate = self;
    }
}

- (void)addMultiManager
{
    _multiManager = [[TCAVCallManager alloc] init];
    _multiManager.multiDelegate = self;
}

- (void)onRecvCallButBusyLine:(AVIMCMD *)cmd
{
    // 占线事件
}

- (void)onRecvBusyLineCall:(AVIMCMD *)cmd
{
    
}

- (void)onRecvConnectCall:(AVIMCMD *)cmd
{
    
}

// 收到挂断消息
- (void)onRecvDisconnectCall:(AVIMCMD *)cmd
{
    
}

- (void)onRecvInviteCall:(AVIMCMD *)cmd
{
    
}

- (void)onRecvNoAnswerCall:(AVIMCMD *)cmd
{
    
}

- (void)onRecvEnableMic:(AVIMCMD *)cmd
{
    
}
- (void)onRecvDisableMic:(AVIMCMD *)cmd
{
    
}

- (void)onRecvEnableCamera:(AVIMCMD *)cmd
{
    
}
- (void)onRecvDisableCamera:(AVIMCMD *)cmd
{
    
}


@end

#endif
