//
//  TCAVRoom.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "TCAVRoom.h"

@implementation TCAVRoom

- (NSString *)liveTitle
{
    return @"TCSoRoom Title";
}

- (void)setPariseCount:(NSInteger)pariseCount
{
    _pariseCount = pariseCount;
}

- (NSInteger)pariseCount
{
    return _pariseCount;
}

- (NSInteger)flowerCount
{
    return _flowerCount;
}

- (void)setflowerCount:(NSInteger)flowerCount
{
    _flowerCount = flowerCount;
}
@end
