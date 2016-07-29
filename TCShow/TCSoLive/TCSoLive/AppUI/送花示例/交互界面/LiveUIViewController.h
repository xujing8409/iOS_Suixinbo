//
//  LiveUIViewController.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "TCAVLiveViewController.h"

/**
 *  集成S_5:集成直播交互界面，需集成TCAVLiveBaseViewController，将交互界面添加到渲染界面之上，本demo中添加到LiveViewController之上
    交互界面在本demo中分为几个模块，LiveUITopView(顶部记录直播时间，点赞数，送花数的视图)，LiveUIBottomView（底部发送消息，送花，点赞 按钮视图），LiveUIMessageView(显示消息视图)，LiveUIFlowerView（收到花时的动画视图），这些视图均布局到LiveUIView中。
 */
@interface LiveUIViewController : TCAVLiveBaseViewController<LiveUITopViewDelegate>
{
@protected
    LiveUIView      *_liveView;
}

#if kSupportIMMsgCache

// 更新消息
- (void)onUIRefreshIMMsg:(AVIMCache *)cache;
// 更新点赞
- (void)onUIRefreshPraise:(AVIMCache *)cache;
//送花消息
- (void)onUIRefreshFlower:(AVIMCache *)cache;

#endif

- (void)uiStartLive;

@end
