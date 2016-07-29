//
//  LiveUIBottomView.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "LiveUIBottomView.h"

@implementation LiveUIBottomView

- (instancetype)initWith:(id<TCSoLiveRoomAble>)room
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _room = room;
        [self addOwnViews];
        [self configOwnViews];
    }
    return self;
}

- (void)addOwnViews
{
    _funBtns = [NSMutableArray array];
    
    //NSString *liveHostId = [_room.liveHost imUserId];
    //NSString *loginUserId = [IMAPlatform sharedInstance].host.imUserId;
    //if (![liveHostId isEqualToString:loginUserId])
    //{
        _sendMsgBtn = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
        [_sendMsgBtn setBackgroundImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_sendMsgBtn addTarget:self action:@selector(sendTextMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendMsgBtn];
        
        [_funBtns addObject:_sendMsgBtn];
    //}
    
    _sendFlowerBtn = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
    [_sendFlowerBtn setBackgroundImage:[UIImage imageNamed:@"flower"] forState:UIControlStateNormal];
    [_sendFlowerBtn addTarget:self action:@selector(sendFlowerMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendFlowerBtn];
    
    [_funBtns addObject:_sendFlowerBtn];
    
    _sendPraiseBtn = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
    [_sendPraiseBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [_sendPraiseBtn setBackgroundImage:[UIImage imageNamed:@"like_hover"] forState:UIControlStateHighlighted];
    [_sendPraiseBtn addTarget:self action:@selector(sendPraiseMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendPraiseBtn];
    
    [_funBtns addObject:_sendPraiseBtn];
}

- (void)relayoutFrameOfSubViews
{
    NSUInteger funBtnCount = _funBtns.count;
    
    CGRect rect = self.bounds;
    rect = CGRectInset(rect, 0, (rect.size.height - 40)/2);
    CGFloat padding = (rect.size.width - 40*funBtnCount)/funBtnCount;
    
    [self alignSubviews:_funBtns horizontallyWithPadding:padding margin:padding/2 inRect:rect];
}

- (void)sendTextMessage
{
    static NSInteger index = 0;
    [_msgHandler sendMessage:[NSString stringWithFormat:@"hello_%lu",(long)index++]];
}

- (void)setMsgHandler:(TCSoMsgHandler *)msgHandler
{
    _msgHandler = msgHandler;
}

- (void)sendPraiseMessage:(ImageTitleButton *)button
{
    if ([[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[[_roomEngine getRoomInfo] liveHost] imUserId]])
    {
        return;
    }
    
    [_msgHandler sendLikeMessage];
    
    TCAVRoom *room = (TCAVRoom *)_room;
    [room setPariseCount:[room pariseCount] + 1];
}

- (void)sendFlowerMessage:(ImageTitleButton *)button
{
    if ([[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[[_roomEngine getRoomInfo] liveHost] imUserId]])
    {
        return;
    }
    
    [_msgHandler sendFlowerMessage];
    
    TCAVRoom *room = (TCAVRoom *)_room;
    [room setFlowerCount:[room flowerCount] + 1];
}
@end
