//
//  TCAVCallRoomEngine.m
//  TIMChat
//
//  Created by AlexiChen on 16/6/6.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCAVCallRoomEngine.h"

@implementation TCAVCallRoomEngine

- (UInt64)roomAuthBitMap
{
    // 电话场景中全权限全开
    return QAV_AUTH_BITS_DEFAULT;
}

- (void)checkRequestHostViewFailed
{
    // 因没有主播概念，不需要再请求主播的画面
    // do nothing
    // 不检查
}


@end
