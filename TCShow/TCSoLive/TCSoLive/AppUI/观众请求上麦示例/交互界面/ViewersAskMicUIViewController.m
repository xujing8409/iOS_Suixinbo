//
//  ViewersAskMicUIViewController.m
//  TCSoLive
//
//  Created by wilderliao on 16/8/9.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "ViewersAskMicUIViewController.h"

@implementation ViewersAskMicUIViewController

- (void)addOwnViews
{
    if (!_liveController.isHost)
    {
        _askMicBtn = [[ImageTitleButton alloc] initWithStyle:ETitleLeftImageRightCenter];
        [_askMicBtn setTitle:@"请求上麦" forState:UIControlStateNormal];
        _askMicBtn.layer.borderColor = kPurpleColor.CGColor;
        _askMicBtn.layer.borderWidth = 1.0;
        _askMicBtn.layer.cornerRadius = 5;
        [_askMicBtn addTarget:self action:@selector(sendAskMicMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_askMicBtn];
    }
    
    _closeBtn = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
}

- (void)onClose
{
    [_liveController alertExitLive];
}

- (void)layoutOnIPhone
{
    if (_askMicBtn)
    {
        [_askMicBtn sizeWith:CGSizeMake(80, 30)];
        [_askMicBtn alignParentTopWithMargin:kDefaultMargin];
        [_askMicBtn layoutParentHorizontalCenter];
    }
    
    [_closeBtn sizeWith:CGSizeMake(30, 30)];
    [_closeBtn alignParentTop];
    [_closeBtn alignParentRight];
}

- (void)sendAskMicMessage:(ImageTitleButton *)button
{
    TCSoMsgMutilHandler *soMsgHandler = (TCSoMsgMutilHandler *)_msgHandler;
    [soMsgHandler sendAskMicMessage];
}

//请求上麦S_7:重写接收自定义消息函数（这里处理观众请求上麦操作）
- (void)onIMHandler:(AVIMMsgHandler *)receiver recvCustomC2CMultiMsg:(AVIMCMD *)msg
{
    DebugLog(@"%@",msg);
    
    NSInteger type = [msg msgType];
    switch (type)
    {
        //观众请求连麦，主播做相应处理
        case TCSoMsgType_ViewersAskMic:
        {
            [self viewersAskMic:msg];
        }
            break;
        //主播同意连麦，观众端做相应处理
        case TCSoMsgType_AcceptViewersAskMic:
        {
            [self onRecvHostInteractChangeAuthAndRole:msg];
        }
            break;
        //主播拒绝连麦，观众端做相应处理
        case TCSoMsgType_RefuseViewersAskMic:
        {
            [self refuseViewersAskMic:msg];
        }
            break;
        case AVIMCMD_Multi_Interact_Join:
        {
            [self onRecvReplyInteractJoin:msg];
        }
            break;
    }
}

- (void)viewersAskMic:(AVIMCMD *)msg
{
    NSString *title = [NSString stringWithFormat:@"收到%@的视频邀请",[msg.sender imUserName]];
    
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:title message:@"是否同意连麦" cancelButtonTitle:@"拒绝" otherButtonTitles:@[@"同意"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        //同意连麦
        if (buttonIndex == 1)
        {
            AVIMCMD *cmd = [[AVIMCMD alloc] initWith:TCSoMsgType_AcceptViewersAskMic];
            [_msgHandler sendCustomC2CMsg:cmd toUser:msg.sender succ:^{
                DebugLog(@"send accept viewers ask mic succ");
            } fail:^(int code, NSString *msg) {
                DebugLog(@"send accept viewers ask mic fail");
            }];
        }
        else//拒绝连麦
        {
            AVIMCMD *cmd = [[AVIMCMD alloc] initWith:TCSoMsgType_RefuseViewersAskMic];
            [_msgHandler sendCustomC2CMsg:cmd toUser:msg.sender succ:^{
                DebugLog(@"send refuse viewers ask mic succ");
            } fail:^(int code, NSString *msg) {
                DebugLog(@"send refuse viewers ask mic fail");
            }];
        }
    }];
    [alert show];
}

- (void)refuseViewersAskMic:(AVIMCMD *)msg
{
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"拒绝连麦" message:@"主播拒绝连麦" cancelButtonTitle:@"好吧" otherButtonTitles:nil handler:nil];
    [alert show];
}

- (void)onRecvHostInteractChangeAuthAndRole:(AVIMCMD *)msg
{
    id<IMUserAble> sender = [msg sender];
    // 本地先修改权限
    //  controller.multiManager ;
    // 然后修改role
    // 再打开相机
    __weak ViewersAskMicUIViewController *ws = self;
    __weak MultiAVIMMsgHandler *wm = (MultiAVIMMsgHandler *)_msgHandler;
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    
    // 检查本地硬件(Mic与相机权限)
    [controller checkPermission:^{
        // 本地没有权限，回复拒绝
        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"无权限" message:@"无相机或麦克风权限" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
        [alert show];
    } permissed:^{
        // 有权限
        [controller.multiManager changeToInteractAuthAndRole:^(TCAVMultiLiveRoomEngine *engine, BOOL isFinished) {
            if (isFinished)
            {
                // 同意
                [wm sendC2CAction:AVIMCMD_Multi_Interact_Join to:sender succ:^{
                    // 进行连麦操作
                    [ws showSelfVideoToOther];
                } fail:^(int code, NSString *msg) {
                    DebugLog(@"code = %d, msg = %@", code, msg);
                }];
            }
            else
            {
                DebugLog(@"isFinished = %d",isFinished);
            }
        }];
    }];
}

- (void)showSelfVideoToOther
{
    // 本地自己开
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    [controller.multiManager registSelfOnRecvInteractRequest];
}

- (void)onRecvReplyInteractJoin:(AVIMCMD *)msg
{
    id<IMUserAble> sender = msg.sender;
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    [controller.multiManager requestViewOf:(id<AVMultiUserAble>)sender];
    
    id<AVMultiUserAble> auser = [controller.multiManager interactUserOf:sender];
    [auser setAvCtrlState:EAVCtrlState_All];
}

- (void)assignWindowResourceTo:(id<AVMultiUserAble>)user isInvite:(BOOL)inviteOrAuto
{
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat screenW = screen.size.width;
    CGFloat screenH = screen.size.height;
    [user setAvInteractArea:CGRectMake(screenW-100, (screenH-120)/2, 100, 120)];
}
@end

@implementation TCSoMsgMutilHandler

//父类中没有处理自定义字段的消息，需要重写这个函数
- (void)onRecvC2CSender:(id<IMUserAble>)sender customMsg:(TIMCustomElem *)msg
{
    id<AVIMMsgAble> cachedMsg = [self cacheRecvC2CSender:sender customMsg:msg];
    [self enCache:cachedMsg noCache:^(id<AVIMMsgAble> msg){
        dispatch_async(dispatch_get_main_queue(), ^{
            // Demo中此类不处理C2C消息
            if (msg)
            {
                DebugLog(@"收到消息：%@", msg);
                // 收到内部的自定义多人互动消
                if ([_roomIMListner respondsToSelector:@selector(onIMHandler:recvCustomC2CMultiMsg:)])
                {
                    [(id<MultiAVIMMsgListener>)_roomIMListner onIMHandler:self recvCustomC2CMultiMsg:msg];
                }
            }
        });
    }];
}

- (void)sendAskMicMessage
{
    AVIMCMD *cmd = [[AVIMCMD alloc] initWith:TCSoMsgType_ViewersAskMic];
    [self sendCustomC2CMsg:cmd toUser:[_imRoomInfo liveHost] succ:^{
        DebugLog(@"send ask mic succ");
    } fail:^(int code, NSString *msg) {
        DebugLog(@"send ask mic fail");
    }];
}

@end