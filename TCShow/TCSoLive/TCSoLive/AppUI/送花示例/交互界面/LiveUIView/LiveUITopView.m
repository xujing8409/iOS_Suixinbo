//
//  LiveUITopView.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "LiveUITopView.h"

@implementation LiveUITopView

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
    static int index = 0;
    DebugLog(@"addOwnViews ------> %d",index++);
    
    if ([self isHost])
    {
        _liveTime = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
        _liveTime.backgroundColor = [UIColor clearColor];
        [_liveTime setTitle:@"00:00" forState:UIControlStateNormal];
        [_liveTime setTitleColor:kWhiteColor forState:UIControlStateNormal];
    }
    else
    {
        _liveTime = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightLeft];
        [_liveTime setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _liveTime.titleLabel.adjustsFontSizeToFitWidth = YES;
        _liveTime.titleLabel.textAlignment = NSTextAlignmentLeft;
        _liveTime.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    [self addSubview:_liveTime];
    
    _avRoomid = [[ImageTitleButton alloc] init];
    _avRoomid.backgroundColor = [UIColor clearColor];
    _avRoomid.titleLabel.adjustsFontSizeToFitWidth = YES;
    _avRoomid.titleLabel.textAlignment = NSTextAlignmentLeft;
    _avRoomid.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_avRoomid];
    
    _imRoomId = [[ImageTitleButton alloc] init];
    _imRoomId.backgroundColor = [UIColor clearColor];
    _imRoomId.titleLabel.adjustsFontSizeToFitWidth = YES;
    _imRoomId.titleLabel.textAlignment = NSTextAlignmentLeft;
    _imRoomId.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_imRoomId];
    
    _praiseCount = [[ImageTitleButton alloc] init];
    _praiseCount.backgroundColor = [UIColor clearColor];
    [self addSubview:_praiseCount];
    
    _flowerCount = [[ImageTitleButton alloc] init];
    _flowerCount.backgroundColor = [UIColor clearColor];
    [self addSubview:_flowerCount];
    
    _closeBtn = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
}

- (void)configOwnViews
{
    NSString *avRoomidStr = [NSString stringWithFormat:@"AV:%d",[AppDelegate sharedAppDelegate].liveRoom.liveAVRoomId];
    [_avRoomid setTitle:avRoomidStr forState:UIControlStateNormal];
    [_avRoomid setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    NSString *imRoomidStr = [NSString stringWithFormat:@"IM:%@",[AppDelegate sharedAppDelegate].liveRoom.liveIMChatRoomId];
    [_imRoomId setTitle:imRoomidStr forState:UIControlStateNormal];
    [_imRoomId setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    [_praiseCount setTitle:@"赞" forState:UIControlStateNormal];
    [_praiseCount setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    [_flowerCount setTitle:@"花" forState:UIControlStateNormal];
    [_flowerCount setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    if ([self isHost])
    {
        [_liveTime setTitle:@"00:00" forState:UIControlStateNormal];
    }
    else
    {
        [_liveTime setTitle:[[_room liveHost] imUserName] forState:UIControlStateNormal];
    }
}

- (void)relayoutFrameOfSubViews
{
    [_liveTime sizeWith:CGSizeMake(50, 30)];
    [_liveTime alignParentTop];
    [_liveTime alignParentLeft];
    
    [_praiseCount sizeWith:CGSizeMake(60, 30)];
    [_praiseCount alignParentTop];
    [_praiseCount layoutParentHorizontalCenter];
    
    [_avRoomid sizeWith:CGSizeMake(60, 15)];
    [_avRoomid layoutToLeftOf:_praiseCount margin:kDefaultMargin];
    
    [_imRoomId sizeWith:CGSizeMake(60, 15)];
    [_imRoomId layoutBelow:_avRoomid];
    [_imRoomId alignLeft:_avRoomid];
    
    [_flowerCount sizeWith:CGSizeMake(60, 30)];
    [_flowerCount layoutToRightOf:_praiseCount];
    
    [_closeBtn sizeWith:CGSizeMake(30, 30)];
    [_closeBtn alignParentTop];
    [_closeBtn alignParentRight];
}

- (BOOL)isHost
{
    return [[IMAPlatform sharedInstance].host isCurrentLiveHost:_room];
}

- (void)onClose
{
    [_delegate onTopViewCloseLive:self];
}

- (void)startLive
{
    [_liveTimer invalidate];
    _liveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onLiveTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_liveTimer forMode:NSRunLoopCommonModes];
}

- (void)pauseLive
{
    if ([self isHost])
    {
        [_liveTimer invalidate];
        _liveTimer = nil;
    }
    
}

- (void)resumeLive
{
    [self startLive];
}

- (void)onLiveTimer
{
    static NSInteger liveTime = 0;
    if ([self isHost])
    {
        
//        NSInteger dur = [_room liveDuration] + 1;
//        [_room setLiveDuration:dur];

        liveTime++;
        NSString *durStr = nil;
        if (liveTime > 3600)
        {
            int h = (int)liveTime/3600;
            int m = (int)(liveTime - h *3600)/60;
            int s = (int)liveTime%60;
            durStr = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
        }
        else
        {
            int m = (int)liveTime/60;
            int s = (int)liveTime%60;
            durStr = [NSString stringWithFormat:@"%02d:%02d", m, s];
        }
        
        [_liveTime setTitle:durStr forState:UIControlStateNormal];
    }
}

- (void)onRefrshPraise
{
    TCAVRoom *room = (TCAVRoom *)_room;
    [_praiseCount setTitle:[NSString stringWithFormat:@"赞: %d", (int)[room pariseCount]] forState:UIControlStateNormal];
}

- (void)onRefreshFlower
{
    TCAVRoom *room = (TCAVRoom *)_room;
    [_flowerCount setTitle:[NSString stringWithFormat:@"花: %d",(int)[room flowerCount]] forState:UIControlStateNormal];
}

@end
