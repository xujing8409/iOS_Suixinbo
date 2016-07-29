//
//  LiveUIBottomView.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 * 底部视图，显示发送消息、送花、点赞按钮的视图
 */
@class LiveUIBottomView;

@protocol TCShowLiveBottomViewDelegate <NSObject>

- (void)onBottomViewSendPraise:(LiveUIBottomView *)bottomView fromButton:(UIButton *)button;

@end

@interface LiveUIBottomView : UIView
{
@protected
    ImageTitleButton    *_sendMsgBtn;
    ImageTitleButton    *_sendFlowerBtn;
    ImageTitleButton    *_sendPraiseBtn;
    
    NSMutableArray      *_funBtns;
    
@protected
    __weak TCSoMsgHandler    *_msgHandler;
    
@protected
    __weak id<TCSoLiveRoomAble> _room;
}

@property (nonatomic, weak) AVIMMsgHandler *msgHandler;

@property (nonatomic, weak) id<TCShowLiveBottomViewDelegate> delegate;

@property (nonatomic, weak) TCAVLiveRoomEngine *roomEngine;

- (instancetype)initWith:(id<TCSoLiveRoomAble>)room;

@end
