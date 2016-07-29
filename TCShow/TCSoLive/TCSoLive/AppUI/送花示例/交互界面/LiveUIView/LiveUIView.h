//
//  LiveUIView.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  布局视图，将交互视图各个模块布局到本视图
 */
@interface LiveUIView : UIView<TCShowLiveBottomViewDelegate>
{
@protected
    LiveUITopView       *_topView;
    LiveUIFlowerView    *_flowerView;
    LiveUIMessageView   *_msgView;
    LiveUIBottomView    *_bottomView;
    
@protected
    __weak id<AVRoomAble>     _room;
    
    __weak TCAVLiveRoomEngine       *_roomEngine;
    __weak AVIMMsgHandler           *_msgHandler;
}

@property (nonatomic, readonly) LiveUITopView       *topView;
@property (nonatomic, readonly) LiveUIMessageView   *msgView;
@property (nonatomic, readonly) LiveUIBottomView    *bottomView;

@property (nonatomic, weak)     TCAVLiveRoomEngine  *roomEngine;
@property (nonatomic, weak)     AVIMMsgHandler      *msgHandler;


- (instancetype)initWith:(id<AVRoomAble>)room;

- (void)startLive;
- (void)pauseLive;
- (void)resumeLive;

- (void)onRecvPraise;
//送花S_2:收到送花消息，立马在界面显示动画提醒
- (void)onRecvFlower;

#if kSupportIMMsgCache

- (void)onRecvPraise:(AVIMCache *)cache;

//送花S_3:每隔2S刷新界面上收到花的总数
- (void)onRecvFlower:(AVIMCache *)cache;

#endif

@end
