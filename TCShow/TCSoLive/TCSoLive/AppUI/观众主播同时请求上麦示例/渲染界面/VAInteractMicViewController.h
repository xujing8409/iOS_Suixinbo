//
//  VAInteractMicViewController.h
//  TCSoLive
//
//  Created by wilderliao on 16/8/10.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "ViewersAskMicViewController.h"

//V:观众 A: 主播
//观众可以请求上麦，主播可以邀请上麦 VAInteractMicViewController 是渲染界面
@interface VAInteractMicViewController : TCAVMultiLiveViewController

@end


// 互邀上麦S_1:继承 TCAVMultiLiveRoomEngine 重写房间引擎
@interface TCSoVAInteractRoomEngine : TCAVMultiLiveRoomEngine

@end
