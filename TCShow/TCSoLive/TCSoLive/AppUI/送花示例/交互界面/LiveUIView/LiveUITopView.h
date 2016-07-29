//
//  LiveUITopView.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 顶部视图，显示直播时间，房间号，点赞数，送花总数等的视图
 */
@class LiveUITopView;

@protocol LiveUITopViewDelegate <NSObject>

- (void)onTopViewCloseLive:(LiveUITopView *)topView;

@end

@interface LiveUITopView : UIView
{
@protected
    ImageTitleButton    *_liveTime;
    
    ImageTitleButton    *_avRoomid;
    ImageTitleButton    *_imRoomId;
    
    ImageTitleButton    *_praiseCount;
    
    ImageTitleButton    *_flowerCount;
    
    ImageTitleButton    *_closeBtn;
    
@protected
    NSTimer             *_liveTimer;
    
@protected
    __weak id<TCSoLiveRoomAble> _room;
}

@property (nonatomic, weak) id<LiveUITopViewDelegate> delegate;

- (instancetype)initWith:(id<TCSoLiveRoomAble>)room;

- (void)startLive;
- (void)pauseLive;
- (void)resumeLive;

- (void)onRefrshPraise;

- (void)onRefreshFlower;

@end
