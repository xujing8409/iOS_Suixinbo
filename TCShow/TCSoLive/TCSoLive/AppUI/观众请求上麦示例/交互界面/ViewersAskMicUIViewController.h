//
//  ViewersAskMicUIViewController.h
//  TCSoLive
//
//  Created by wilderliao on 16/8/9.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "TCAVLiveViewController.h"

@interface ViewersAskMicUIViewController : TCAVLiveBaseViewController
{
    ImageTitleButton    *_closeBtn;
    ImageTitleButton    *_askMicBtn;
}

- (void)assignWindowResourceTo:(id<AVMultiUserAble>)user isInvite:(BOOL)inviteOrAuto;

@end

//请求上麦S_3 :集成MultiAVIMMsgHandler重写消息句柄
@interface TCSoMsgMutilHandler : MultiAVIMMsgHandler

//在自己的msghandler中实现发送请求上麦的自定义消息函数
- (void)sendAskMicMessage;

@end
