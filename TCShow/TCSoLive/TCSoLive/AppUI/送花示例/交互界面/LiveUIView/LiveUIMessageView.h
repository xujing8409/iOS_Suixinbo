//
//  LiveUIMessageView.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  消息视图，显示IM消息，在本dmeo中只有固定的文本消息"hello_X"
 */
@interface LiveUIMessageView : UIView<UITableViewDataSource, UITableViewDelegate>
{
@protected
    UITableView         *_tableView;        // 消息列表
    NSMutableArray      *_liveMessages;     // 缓存的消息数量
    
    NSInteger           _msgCount;          // 统计点评的赞数
    
    BOOL                _isPureMode;
}

// 消息数量，评论数
@property (nonatomic, readonly) NSInteger msgCount;

// 即时显示的
// 插入user的message
- (void)insertText:(NSString *)message from:(id<IMUserAble>)user;

- (void)insertMsg:(id<AVIMMsgAble>)msg;

// 主要是上线消息
- (void)insertOnlineFrom:(id<IMUserAble>)user;

// 延迟显示
- (void)insertCachedMsg:(AVIMCache *)msgCache;

- (void)changeToMode:(BOOL)pure;
@end
