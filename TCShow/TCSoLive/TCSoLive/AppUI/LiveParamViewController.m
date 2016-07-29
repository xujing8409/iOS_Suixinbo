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

- (void)addOwnViews
{
    _avRoomId = [[UITextField alloc] init];
    _avRoomId.layer.borderColor = kGrayColor.CGColor;
    _avRoomId.layer.borderWidth = 1.0;
    _avRoomId.layer.cornerRadius = 5.0;
    _avRoomId.placeholder = @"音视频房间ID";
    [self.view addSubview:_avRoomId];
    
    _groupId = [[UITextField alloc] init];
    _groupId.layer.borderColor = kGrayColor.CGColor;
    _groupId.layer.borderWidth = 1.0;
    _groupId.layer.cornerRadius = 5.0;
    _groupId.placeholder = @"聊天室ID";
    [self.view addSubview:_groupId];
    
    _hostId = [[UITextField alloc] init];
    _hostId.layer.borderColor = kGrayColor.CGColor;
    _hostId.layer.borderWidth = 1.0;
    _hostId.layer.cornerRadius = 5.0;
    _hostId.placeholder = @"主播ID";
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
    if (_avRoomId.text.length == 0 || _groupId.text.length == 0)
    {
        [[HUDHelper sharedInstance] tipMessage:@"请输入正确的参数"];
        return;
    }
    
    ((TCUser *)([AppDelegate sharedAppDelegate].liveRoom.liveHost)).uid = _hostId.text.length ? _hostId.text : [IMAPlatform sharedInstance].host.imUserId;
    ((TCUser *)([AppDelegate sharedAppDelegate].liveRoom.liveHost)).name = _hostId.text.length ? _hostId.text : [IMAPlatform sharedInstance].host.imUserId;
    [AppDelegate sharedAppDelegate].liveRoom.liveAVRoomId = [_avRoomId.text intValue];
    [AppDelegate sharedAppDelegate].liveRoom.liveIMChatRoomId = _groupId.text;
    [AppDelegate sharedAppDelegate].liveRoom.liveTitle = @"hellotx";

    LiveViewController *liveVc = [[LiveViewController alloc] initWith:[AppDelegate sharedAppDelegate].liveRoom user:[IMAPlatform sharedInstance].host];
    [[AppDelegate sharedAppDelegate] pushViewController:liveVc];
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
    
    [_groupId sameWith:_avRoomId];
    [_groupId layoutBelow:_avRoomId margin:kDefaultMargin];
    
    [_hostId sameWith:_groupId];
    [_hostId layoutBelow:_groupId margin:kDefaultMargin];
    
    [_joinButton sameWith:_hostId];
    [_joinButton layoutBelow:_hostId margin:kDefaultMargin*3];
    
    [_exitButton sameWith:_joinButton];
    [_exitButton layoutBelow:_joinButton margin:kDefaultMargin];
    
    
}

@end
