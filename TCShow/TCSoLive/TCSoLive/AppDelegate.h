//
//  AppDelegate.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  集成S_1: 重写AppDelegate，继承于IMAAppDelegate。
    同时删除创建工程时自动生成的ViewController.h/m和Main.storyboard文件（记得在plist文件中移除Main storyboard file base name 选项哦）
 */
@interface AppDelegate : IMAAppDelegate

@property (nonatomic, strong) TCUser *liveHost;

@property (nonatomic, strong) TCAVRoom *liveRoom;

@end

