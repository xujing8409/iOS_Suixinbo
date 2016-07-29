//
//  TCAVRoom.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCAVRoom : NSObject<AVRoomAble>
{
@protected
    NSInteger _pariseCount;
    NSInteger _flowerCount;
}

@property (nonatomic, copy) NSString *liveIMChatRoomId;
@property (nonatomic, strong) id<IMUserAble> liveHost;
@property (nonatomic, assign) int liveAVRoomId;
@property (nonatomic, copy) NSString * liveTitle;

@property (nonatomic, assign) NSInteger pariseCount;

@property (nonatomic, assign) NSInteger flowerCount;

@end
