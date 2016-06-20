//
//  C2CVoiceViewController.m
//  TCAVIntergrateDemo
//
//  Created by AlexiChen on 16/5/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "C2CVoiceViewController.h"

@implementation C2CVoiceRoomEngine

- (UInt64)roomAuthBitMap
{
    return QAV_AUTH_BITS_CREATE_ROOM | QAV_AUTH_BITS_JOIN_ROOM | QAV_AUTH_BITS_RECV_AUDIO | QAV_AUTH_BITS_RECV_VIDEO | QAV_AUTH_BITS_RECV_SUB | QAV_AUTH_BITS_SEND_AUDIO;
}

@end

@interface C2CVoiceViewController ()

@end

@implementation C2CVoiceViewController

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
        id<AVMultiUserAble> ah = (id<AVMultiUserAble>)_currentUser;
        [ah setAvMultiUserState:_isHost ? AVMultiUser_Host : AVMultiUser_Guest];
        [ah setAvCtrlState:[self defaultAVHostConfig]];
        _roomEngine = [[C2CVoiceRoomEngine alloc] initWith:(id<IMHostAble, AVMultiUserAble>)_currentUser enableChat:_enableIM];
        _roomEngine.delegate = self;
    }
}

- (NSInteger)defaultAVHostConfig
{
    // 添加推荐配置
    return EAVCtrlState_Speaker | EAVCtrlState_Mic;
    
}


@end
