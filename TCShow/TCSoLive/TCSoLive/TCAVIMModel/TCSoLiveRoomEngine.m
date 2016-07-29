//
//  TCSoLiveRoomEngine.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "TCSoLiveRoomEngine.h"

@implementation TCSoLiveRoomEngine

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
        return @"NormalGuest";
    }
}

@end
