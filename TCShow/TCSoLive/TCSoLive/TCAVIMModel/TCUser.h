//
//  TCUser.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCUser : NSObject<IMUserAble, AVMultiUserAble>

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, assign) NSInteger avCtrlState;
@property (nonatomic, assign) NSInteger avMultiUserState;
@property (nonatomic, assign) CGRect avInteractArea;
@property (nonatomic, weak) UIView *avInvisibleInteractView;

@end
