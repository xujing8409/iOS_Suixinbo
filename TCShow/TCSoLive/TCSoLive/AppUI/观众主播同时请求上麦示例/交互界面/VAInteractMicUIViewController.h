//
//  VAInteractMicUIViewController.h
//  TCSoLive
//
//  Created by wilderliao on 16/8/10.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "ViewersAskMicUIViewController.h"

@interface VAInteractMicUIViewController : TCAVLiveBaseViewController
{
    ImageTitleButton    *_closeBtn;
    ImageTitleButton    *_askMicBtn;
}

- (void)assignWindowResourceTo:(id<AVMultiUserAble>)user isInvite:(BOOL)inviteOrAuto;

@end


// 互邀上麦S_2:继承 MultiAVIMMsgHandler 重写消息句柄
@interface TCSoVAInteractMsgHandler : MultiAVIMMsgHandler

//在自己的msghandler中实现发送请求上麦的自定义消息函数（观众端使用）
- (void)sendAskMicMessage;

@end



