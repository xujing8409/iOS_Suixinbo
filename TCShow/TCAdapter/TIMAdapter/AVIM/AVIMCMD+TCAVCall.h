//
//  AVIMCMD+TCAVCall.h
//  TIMChat
//
//  Created by AlexiChen on 16/6/6.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//
#if kSupportCallScene
#import "AVIMMsg.h"

@protocol AVIMCallHandlerAble <NSObject>

- (void)sendCallMsg:(AVIMCMD *)callCmd finish:(CommonFinishBlock)block;

@end

@interface AVIMCMD (TCAVCall)<AVRoomAble>

@property (nonatomic, strong) NSMutableDictionary *callInfo;
// 创建通话自定义命令
- (instancetype)initWithCall:(NSInteger)command avRoomID:(int)roomid group:(NSString *)gid type:(BOOL)isVoiceCall;
- (instancetype)initWithCall:(NSInteger)command avRoomID:(int)roomid group:(NSString *)gid type:(BOOL)isVoiceCall tip:(NSString *)tip;

- (BOOL)isVoiceCall;
- (BOOL)isTCAVCallCMD;

@end
#endif