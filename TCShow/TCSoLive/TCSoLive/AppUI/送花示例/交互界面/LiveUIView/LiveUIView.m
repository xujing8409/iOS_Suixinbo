//
//  LiveUIView.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "LiveUIView.h"

@implementation LiveUIView

- (instancetype)initWith:(id<TCSoLiveRoomAble>)room
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _room = room;
        [self addOwnViews];
    }
    return self;
}

- (void)addOwnViews
{
    _topView = [[LiveUITopView alloc] initWith:(id<TCSoLiveRoomAble>)_room];
    [self addSubview:_topView];
    
    _flowerView = [[LiveUIFlowerView alloc] init];
    [self addSubview:_flowerView];
    
    _msgView = [[LiveUIMessageView alloc] init];
    [self addSubview:_msgView];
    
    NSString *liveHostId = [_room.liveHost imUserId];
    NSString *loginUserId = [IMAPlatform sharedInstance].host.imUserId;
    if (![liveHostId isEqualToString:loginUserId])
    {
        _bottomView = [[LiveUIBottomView alloc] initWith:(id<TCSoLiveRoomAble>)_room];
        _bottomView.delegate = self;
        [self addSubview:_bottomView];
    }
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    
    [_topView setFrameAndLayout:CGRectMake(0, 0, rect.size.width, 50)];
    
    [_flowerView sizeWith:CGSizeMake(100, 30)];
    [_flowerView layoutBelow:_topView margin:kDefaultMargin];
    
    CGPoint point = CGPointMake(-100, 0);
    [_flowerView move:point];
    
    if (_bottomView)
    {
        [_bottomView sizeWith:CGSizeMake(rect.size.width, 60)];
        [_bottomView alignParentBottomWithMargin:0];
        [_bottomView relayoutFrameOfSubViews];
    }
    
    [_msgView sizeWith:CGSizeMake((NSInteger)(rect.size.width * 0.7), 210)];
    [_msgView layoutBelow:_topView margin:30+kDefaultMargin];
    if (_bottomView)
    {
        [_msgView scaleToAboveOf:_bottomView margin:kDefaultMargin];
    }
    else
    {
        [_msgView alignParentBottom];
    }
    [_msgView relayoutFrameOfSubViews];
}

- (void)startLive
{
    [_topView startLive];
}
- (void)pauseLive
{
    [_topView pauseLive];
}
- (void)resumeLive
{
    [_topView resumeLive];
}

- (void)setRoomEngine:(TCAVLiveRoomEngine *)roomEngine
{
    _roomEngine = roomEngine;
    
    if (_bottomView)
    {
        _bottomView.roomEngine = roomEngine;
    }
}

- (void)onBottomViewSendPraise:(LiveUIBottomView *)bottomView fromButton:(UIButton *)button
{
    [_msgHandler sendLikeMessage];
//    [_room setLivePraise:[_room livePraise] + 1];
    
}

- (void)onRecvPraise
{
    TCAVRoom *room = (TCAVRoom *)_room;
    NSInteger praise = [room pariseCount];
    [room setPariseCount:praise + 1];
}

- (void)onRecvFlower
{
    NSLog(@"onRecvFlower nocache");
    TCAVRoom *room = (TCAVRoom *)_room;
    NSInteger flower = [room flowerCount];
    [room setFlowerCount:flower+1];
    
    [_flowerView startAnimation];
}

#if kSupportIMMsgCache
- (void)onRecvPraise:(AVIMCache *)cache
{
    TCAVRoom *room = (TCAVRoom *)_room;
    NSInteger praise = [room pariseCount];
    [room setPariseCount:praise + cache.count];

    [_topView onRefrshPraise];
}

- (void)onRecvFlower:(AVIMCache *)cache
{
//    TCAVRoom *room = (TCAVRoom *)_room;
//    NSInteger flower = [room flowerCount];
//    [room setFlowerCount:flower + cache.count];

    NSLog(@"onRecvFlower:(AVIMCache *)cache");
    [_topView onRefreshFlower];
}
#endif

@end
