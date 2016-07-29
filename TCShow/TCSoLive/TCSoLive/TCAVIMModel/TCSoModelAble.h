//
//  TCSoModelAble.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/19.
//  Copyright © 2016年 Tencent. All rights reserved.
//


#import <Foundation/Foundation.h>

// 用户可以在此处增加在AVIMAble.h在提到的接口方法

@protocol TCSoLiveRoomAble <AVRoomAble>

// 直播时间
@property (nonatomic, assign) NSInteger liveDuration;

// 点赞数
@property (nonatomic, assign) NSInteger livePraise;

//// 在线人数
//@property (nonatomic, assign) NSInteger liveAudience;
//
//// 封面
//- (NSString *)liveCover;
//
//- (NSInteger)liveWatchCount;
@end


//为避免重复自定命令字段从AVIMCMD_Custom开始赋值
typedef  NS_ENUM(NSInteger, TCSoAVIMCommand)
{
    TCSoAVIMCommand_Custom = AVIMCMD_Custom,     // 用户自定义消息类型开始值（这句直接copy到自己的代码中）
    TCSoAVIMCommand_Flower,                      // 送花消息
};
