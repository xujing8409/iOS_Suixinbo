//
//  TCUser.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "TCUser.h"

@implementation TCUser

- (NSString *)imUserId
{
    return _uid;
}

- (NSString *)imUserName
{
    return _name.length ? _name : _uid;
}

- (NSString *)imUserIconUrl
{
    return _icon;
}
@end
