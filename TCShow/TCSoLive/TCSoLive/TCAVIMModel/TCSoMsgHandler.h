//
//  TCSoMsgHandler.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "AVIMMsgHandler.h"

/**
 *  送花S_1:重写AVIMMsgHandler，新增送花接口。这里发送送花消息之后，接收消息是在LiveUIView类里面，onRecvFlower函数接收到送花消息，立马在界面显示动画，提示收到花，- (void)onRecvFlower:(AVIMCache *)cache函数是每隔2S刷新一次，这里可以刷新界面顶部接收到的花的总数
 */
@interface TCSoMsgHandler : AVIMMsgHandler

- (void)sendFlowerMessage;

@end
