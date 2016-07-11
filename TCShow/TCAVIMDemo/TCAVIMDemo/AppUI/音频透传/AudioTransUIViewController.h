//
//  AudioTransUIViewController.h
//  TCAVIMDemo
//
//  Created by AlexiChen on 16/7/7.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioTransUIViewController : UIViewController<TCAVLiveUIAbleView>

@property (nonatomic, weak) TCAVBaseViewController *liveController;
@property (nonatomic, weak) TCAVBaseRoomEngine *roomEngine;
@property (nonatomic, weak) AVIMMsgHandler *msgHandler;

- (void)onEnterBackground;
- (void)onEnterForeground;

@end
