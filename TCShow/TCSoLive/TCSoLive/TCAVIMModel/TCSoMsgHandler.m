//
//  TCSoMsgHandler.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "TCSoMsgHandler.h"

@implementation TCSoMsgHandler

//这里不用缓存消息，不缓存送花消息，在收到送花消息时，就立刻显示。而界面顶部的收花总数，是存在_room信息里面的
- (void)createMsgCache
{
    [super createMsgCache];
    if (_msgCache)
    {
//        [_msgCache setObject:[[AVIMCache alloc] initWith:10] forKey:@(TCSoAVIMCommand_Flower)];
    }
}

- (void)sendFlowerMessage
{
    AVIMCMD *cmd = [[AVIMCMD alloc] initWith:TCSoMsgType_Flower];
    
    [self sendCustomGroupMsg:cmd succ:^{
        DebugLog("send flower succ");
    } fail:^(int code, NSString *msg) {
        
    }];
}

- (id<AVIMMsgAble>)onRecvSender:(id<IMUserAble>)sender tipMessage:(NSString *)msg
{
    TCSoLiveMsg *amsg = [[TCSoLiveMsg alloc] initWith:sender message:msg];
    if (!_isPureMode)
    {
        [amsg prepareForRender];
    }
    return amsg;
}
- (id<AVIMMsgAble>)onRecvSenderEnterLiveRoom:(id<IMUserAble>)sender
{
    TCSoLiveMsg *lm = [[TCSoLiveMsg alloc] initWith:sender message:@"进来了"];
    if (!_isPureMode)
    {
        [lm prepareForRender];
    }
    lm.isMsg = NO;
    return lm;
}

- (id<AVIMMsgAble>)onRecvSenderLeaveLiveRoom:(id<IMUserAble>)sender
{
    TCSoLiveMsg *amsg = [[TCSoLiveMsg alloc] initWith:sender message:@"暂时离开了"];
    if (!_isPureMode)
    {
        [amsg prepareForRender];
    }
    return amsg;
}
- (id<AVIMMsgAble>)onRecvSenderBackLiveRoom:(id<IMUserAble>)sender
{
    TCSoLiveMsg *amsg = [[TCSoLiveMsg alloc] initWith:sender message:@"回来了"];
    if (!_isPureMode)
    {
        [amsg prepareForRender];
    }
    return amsg;
}
- (id<AVIMMsgAble>)onRecvSenderExitLiveRoom:(id<IMUserAble>)sender
{
    TCSoLiveMsg *lm = [[TCSoLiveMsg alloc] initWith:sender message:@"离开了"];
    if (!_isPureMode)
    {
        [lm prepareForRender];
    }
    lm.isMsg = NO;
    return lm;
}

- (id<AVIMMsgAble>)cacheRecvGroupSender:(id<IMUserAble>)sender textMsg:(NSString *)msg
{
    TCSoLiveMsg *lm = [[TCSoLiveMsg alloc] initWith:sender message:msg];
    lm.isMsg = YES;
    if (!_isPureMode)
    {
        [lm prepareForRender];
    }
    return lm;
}


@end
