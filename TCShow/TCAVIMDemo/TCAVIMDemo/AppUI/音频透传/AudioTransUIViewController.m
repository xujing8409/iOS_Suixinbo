//
//  AudioTransUIViewController.m
//  TCAVIMDemo
//
//  Created by AlexiChen on 16/7/7.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "AudioTransUIViewController.h"

@interface AudioTransUIViewController ()

@end

@implementation AudioTransUIViewController

- (instancetype)initWith:(TCAVBaseViewController *)controller
{
    if (self = [super init])
    {
        _liveController = controller;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kClearColor;
}

- (void)onEnterBackground
{
    
}
- (void)onEnterForeground
{
    
}


- (IBAction)onMicTrans:(UIButton *)sender
{
    TCAVLiveRoomEngine *re = (TCAVLiveRoomEngine *)_roomEngine;
    if (!sender.selected)
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"48000_2" withExtension:@"pcm"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        BOOL succ = [re startMicAudioTransmission:data];
        sender.selected = succ ? YES : NO;
    }
    else
    {
        BOOL succ = [re startMicAudioTransmission:nil];
        sender.selected = succ ? NO : YES;
    }
    
    
}

- (IBAction)onSpeakerTrans:(UIButton *)sender
{
    TCAVLiveRoomEngine *re = (TCAVLiveRoomEngine *)_roomEngine;
    if (!sender.selected)
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"48000_2" withExtension:@"pcm"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        BOOL succ = [re startSpeakerAudioTransmission:data];
        sender.selected = succ ? YES : NO;
    }
    else
    {
        BOOL succ = [re startSpeakerAudioTransmission:nil];
        sender.selected = succ ? NO : YES;
    }

}
- (IBAction)onClose:(id)sender
{
     [_liveController exitLive];
}



@end
