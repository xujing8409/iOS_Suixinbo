//
//  LiveParamViewController.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "LiveParamViewController.h"

@interface LiveParamViewController ()

@end

@implementation LiveParamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"直播间信息";
    
    [self addTapBlankToHideKeyboardGesture];
}
- (void)configDemoType:(DemoType)type
{
    _demoType = type;
}
- (void)addOwnViews
{
    _avRoomId = [[UITextField alloc] init];
    _avRoomId.layer.borderColor = kGrayColor.CGColor;
    _avRoomId.layer.borderWidth = 1.0;
    _avRoomId.layer.cornerRadius = 5.0;
    _avRoomId.placeholder = @"音视频房间ID(int)";
    [self.view addSubview:_avRoomId];
    
//    _groupId = [[UITextField alloc] init];
//    _groupId.layer.borderColor = kGrayColor.CGColor;
//    _groupId.layer.borderWidth = 1.0;
//    _groupId.layer.cornerRadius = 5.0;
//    _groupId.placeholder = @"聊天室ID";
//    [self.view addSubview:_groupId];
    
    _hostId = [[UITextField alloc] init];
    _hostId.layer.borderColor = kGrayColor.CGColor;
    _hostId.layer.borderWidth = 1.0;
    _hostId.layer.cornerRadius = 5.0;
    _hostId.placeholder = @"主播ID(无:创建,有:加入)";//不输入主播id则创建房间，输入主播id则加入到对应主播的房间
    [_hostId setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_hostId setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.view addSubview:_hostId];
    
    _joinButton = [[ImageTitleButton alloc] initWithStyle:ETitleLeftImageRightCenter];
    [_joinButton setTitle:@"加入" forState:UIControlStateNormal];
    [_joinButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_joinButton setTitleColor:kLightGrayColor forState:UIControlStateHighlighted];
    [_joinButton setBackgroundColor:kBlueColor];
    _joinButton.layer.cornerRadius = 5.0;
    [_joinButton addTarget:self action:@selector(onJoin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_joinButton];
    
    _exitButton = [[ImageTitleButton alloc] initWithStyle:ETitleLeftImageRightCenter];
    [_exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [_exitButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_exitButton setTitleColor:kLightGrayColor forState:UIControlStateHighlighted];
    [_exitButton setBackgroundColor:kRedColor];
    _exitButton.layer.cornerRadius = 5.0;
    [_exitButton addTarget:self action:@selector(onLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exitButton];
    
}

- (void)onJoin:(ImageTitleButton *)button
{
    
    if (_avRoomId.text.length == 0)
    {
        [[HUDHelper sharedInstance] tipMessage:@"请输入房间ID"];
        return;
    }
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    TCUser *user = (TCUser *)(appDelegate.liveRoom.liveHost);
    IMAHost *host = [IMAPlatform sharedInstance].host;
    
    user.uid = _hostId.text.length ? _hostId.text : host.imUserId;
    user.name = _hostId.text.length ? _hostId.text : host.imUserId;
    //在本例子中，用户只传入了一个int型的房间id，所以将av房间和im房间id共用一个id
    appDelegate.liveRoom.liveAVRoomId = [_avRoomId.text intValue];
    appDelegate.liveRoom.liveIMChatRoomId = _avRoomId.text;//_groupId.text.length ? _groupId.text : _avRoomId.text;
    appDelegate.liveRoom.liveTitle = @"hellotx";

    TCAVLiveViewController *vc;
    switch (_demoType)
    {
        case DemoType_SendFlower:
            vc = [[LiveViewController alloc] initWith:appDelegate.liveRoom user:host];
            [appDelegate pushViewController:vc];
            break;
            
        case DemoType_ViewersInviteAnchor:
            
            vc = [[ViewersAskMicViewController alloc] initWith:appDelegate.liveRoom user:host];
            [appDelegate pushViewController:vc];
            
            break;
        case DemoType_VAInteractMic:
            
            vc = [[VAInteractMicViewController alloc] initWith:appDelegate.liveRoom user:host];
            [appDelegate pushViewController:vc];
            
            break;
            
        default:
            break;
    }
    
}

- (void)onLogout:(ImageTitleButton *)button
{
    [[HUDHelper sharedInstance] syncLoading:@"正在退出"];
    [[IMAPlatform sharedInstance] logout:^{
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"退出成功" delay:0.5 completion:^{
            [[AppDelegate sharedAppDelegate] enterLoginUI];
        }];
        
    } fail:^(int code, NSString *err) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err) delay:2 completion:^{
            [[AppDelegate sharedAppDelegate] enterLoginUI];
        }];
    }];
}

- (void)configOwnViews
{
}

- (void)layoutOnIPhone
{
    [_avRoomId sizeWith:CGSizeMake(self.view.bounds.size.width / 2, 44)];
    [_avRoomId alignParentTopWithMargin:kDefaultMargin*10];
    [_avRoomId layoutParentHorizontalCenter];
    
//    [_groupId sameWith:_avRoomId];
//    [_groupId layoutBelow:_avRoomId margin:kDefaultMargin];
    
    [_hostId sameWith:_avRoomId];
    [_hostId layoutBelow:_avRoomId margin:kDefaultMargin];
    
    [_joinButton sameWith:_hostId];
    [_joinButton layoutBelow:_hostId margin:kDefaultMargin*3];
    
    [_exitButton sameWith:_joinButton];
    [_exitButton layoutBelow:_joinButton margin:kDefaultMargin];
    
    
}

@end
