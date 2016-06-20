//
//  AVIMCMD+TCAVCall.m
//  TIMChat
//
//  Created by AlexiChen on 16/6/6.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//
#if kSupportCallScene
#import "AVIMCMD+TCAVCall.h"

@implementation AVIMCMD (TCAVCall)

static NSString *const kAVIMCMDCallInfo = @"kAVIMCMDCallInfo";

- (NSMutableDictionary *)callInfo
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, (__bridge const void *)kAVIMCMDCallInfo);
    return dic;
}

- (void)setCallInfo:(NSMutableDictionary *)callInfo
{
    objc_setAssociatedObject(self, (__bridge const void *)kAVIMCMDCallInfo, callInfo, OBJC_ASSOCIATION_RETAIN);
}


- (instancetype)initWithCall:(NSInteger)command avRoomID:(int)roomid group:(NSString *)gid type:(BOOL)isVoiceCall
{
    return [self initWithCall:command avRoomID:roomid group:gid type:isVoiceCall tip:nil];
}

- (instancetype)initWithCall:(NSInteger)command avRoomID:(int)roomid group:(NSString *)gid type:(BOOL)isVoiceCall tip:(NSString *)tip
{
    if (roomid < 0)
    {
        DebugLog(@"房间号能数不合法");
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addNumber:@(roomid) forKey:kTCAVCall_AVRoomID];
    [dic addNumber:@(isVoiceCall) forKey:kTCAVCall_CallType];
    
    if (gid && gid.length)
    {
        [dic addString:gid forKey:kTCAVCall_IMGroupID];
    }
    
    if (tip && tip.length)
    {
        [dic addString:tip forKey:kTCAVCall_CallTip];
    }
    
    [dic setObject:@([[NSDate date] timeIntervalSince1970]) forKey:kTCAVCall_CallDate];
    
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *param = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self = [self initWith:command param:param];
        self.callInfo = dic;
        return self;
    }
    else
    {
        DebugLog(@"[%@] AVIMCMD is not valid: %@", [self class], dic);
        return nil;
    }
}

- (BOOL)isVoiceCall
{
    return [(NSNumber *)self.callInfo[kTCAVCall_CallType] boolValue];
}

- (BOOL)isTCAVCallCMD
{
    return self.userAction > AVIMCMD_Call && self.userAction < AVIMCMD_Call_AllCount;
}

// 聊天室Id
- (NSString *)liveIMChatRoomId
{
    return self.callInfo[kTCAVCall_IMGroupID];
}

- (void)setLiveIMChatRoomId:(NSString *)liveIMChatRoomId
{
    [self.callInfo addString:liveIMChatRoomId forKey:kTCAVCall_IMGroupID];
}

// 当前主播信息
- (id<IMUserAble>)liveHost
{
   return self.sender;
}

// 直播房间Id
- (int)liveAVRoomId
{
    return [(NSNumber *)self.callInfo[kTCAVCall_AVRoomID] intValue];
}

// 直播标题，用于创建直播IM聊天室，不能为空
- (NSString *)liveTitle
{
    return nil;
}

@end
#endif