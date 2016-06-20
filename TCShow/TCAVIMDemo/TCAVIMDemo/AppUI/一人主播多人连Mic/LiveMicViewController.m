//
//  LiveMicViewController.m
//  TCAVIntergrateDemo
//
//  Created by AlexiChen on 16/5/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "LiveMicViewController.h"


@implementation LiveMicRoomEngine

- (UInt64)roomAuthBitMap
{
    if ([self isHostLive])
    {
        // 主播权限全开
        return QAV_AUTH_BITS_DEFAULT;
    }
    else
    {
        // 观众只开接收权限 +
        return QAV_AUTH_BITS_JOIN_ROOM | QAV_AUTH_BITS_RECV_AUDIO | QAV_AUTH_BITS_RECV_VIDEO | QAV_AUTH_BITS_RECV_SUB | QAV_AUTH_BITS_SEND_AUDIO;
    }
}

@end

@interface LiveMicViewController ()

@end

@implementation LiveMicViewController

- (void)addLiveView
{
    // 子类重写
    UserAppBaseUIViewController *uivc = [[UserAppBaseUIViewController alloc] initWith:self];
    [self addChild:uivc inRect:self.view.bounds];
    
    _liveView = uivc;
}

- (void)createRoomEngine
{
    if (!_roomEngine)
    {
        id<AVUserAble> ah = (id<AVUserAble>)_currentUser;
        [ah setAvCtrlState:[self defaultAVHostConfig]];
        _roomEngine = [[LiveMicRoomEngine alloc] initWith:(id<IMHostAble, AVUserAble>)_currentUser enableChat:_enableIM];
        _roomEngine.delegate = self;
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
        return EAVCtrlState_All;
    }
    else
    {
        return EAVCtrlState_Speaker | EAVCtrlState_Mic;
    }
}


@end
