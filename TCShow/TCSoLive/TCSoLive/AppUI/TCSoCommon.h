//
//  TCSoCommon.h
//  TCSoLive
//
//  Created by wilderliao on 16/8/11.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#ifndef TCSoCommon_h
#define TCSoCommon_h

typedef NS_ENUM(NSInteger, TCSoMsgType)
{
    //为避免重复自定命令字段从AVIMCMD_Custom开始赋值

    TCSoMsgType_Custom = AVIMCMD_Custom,     // 用户自定义消息类型开始值（这句直接copy到自己的代码中）
    TCSoMsgType_Flower,                      // 送花消息
    

    //请求上麦S_2:自定义消息类型，从 AVIMCMD_Multi_Custom 开始取值

    TCSoMsgType_Multi_Custom = AVIMCMD_Multi_Custom,
    TCSoMsgType_ViewersAskMic,               // 观众请求上麦
    TCSoMsgType_RefuseViewersAskMic,         // 拒绝观众上麦请求
    TCSoMsgType_AcceptViewersAskMic,         // 同意观众上麦请求
    
};
#endif /* TCSoCommon_h */
