//
//  AudioTransViewController.m
//  TCAVIMDemo
//
//  Created by AlexiChen on 16/7/7.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "AudioTransViewController.h"
#import "AudioTransUIViewController.h"

@interface AudioTransViewController ()

@end

@implementation AudioTransViewController

- (void)addLiveView
{
    // 子类重写
    AudioTransUIViewController *uivc = [[AudioTransUIViewController alloc] initWith:self];
    [self addChild:uivc inRect:self.view.bounds];
    
    _liveView = uivc;
}


- (NSInteger)defaultAVHostConfig
{
    
    return EAVCtrlState_All;
}

@end
