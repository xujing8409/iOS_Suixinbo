//
//  C2CVideoViewController.m
//  TCAVIntergrateDemo
//
//  Created by AlexiChen on 16/5/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "C2CVideoViewController.h"
#import "C2CVideoUIViewController.h"


@implementation C2CVideoRoomEngine

- (UInt64)roomAuthBitMap
{
    return QAV_AUTH_BITS_DEFAULT;
}

@end

@interface C2CVideoViewController ()

@end

@implementation C2CVideoViewController

- (void)addLiveView
{
    // 子类重写
    C2CVideoUIViewController *uivc = [[C2CVideoUIViewController alloc] initWith:self];
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
        _roomEngine = [[C2CVideoRoomEngine alloc] initWith:(id<IMHostAble, AVMultiUserAble>)_currentUser enableChat:_enableIM];
        _roomEngine.delegate = self;
    }
}

- (NSInteger)defaultAVHostConfig
{
    
    return EAVCtrlState_All;
}

//====================================================

// 外部分配user窗口位置，此处可在界面显示相应的小窗口
- (void)onAVIMMIMManager:(TCAVIMMIManager *)mgr assignWindowResourceTo:(id<AVMultiUserAble>)user isInvite:(BOOL)inviteOrAuto
{
    [(C2CVideoUIViewController *)_liveView assignWindowResourceTo:user isInvite:inviteOrAuto];
}

- (void)onAVEngine:(TCAVBaseRoomEngine *)engine enableCamera:(BOOL)succ tipInfo:(NSString *)tip
{
    [super onAVEngine:engine enableCamera:succ tipInfo:tip];
    if (_isHost && succ)
    {
        [_multiManager registSelfOnRecvInteractRequest];
    }
}




@end
