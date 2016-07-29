//
//  TCSoLiveMsg.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "AVIMMsg.h"

@interface TCSoLiveMsg : AVIMMsg

@property (nonatomic, assign) BOOL isMsg;               // NO：进入消息，YES：聊天消息
@property (nonatomic, strong) UIColor *nameColor;       // 显示名字的颜色

@property (nonatomic, strong) NSAttributedString *avimMsgRichText;
@property (nonatomic, assign) CGSize avimMsgShowSize;

+ (CGFloat)defaultShowHeightOf:(TCSoLiveMsg *)item inSize:(CGSize)size;

- (instancetype)initWith:(id<IMUserAble>)user message:(NSString *)message;

@end
