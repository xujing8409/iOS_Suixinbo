//
//  VAInteractMicUIViewController.m
//  TCSoLive
//
//  Created by wilderliao on 16/8/10.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "VAInteractMicUIViewController.h"

@implementation VAInteractMicUIViewController

static __weak UIAlertView *kInteractAlert = nil;
static BOOL kRectHostCancelInteract = NO;

- (void)addOwnViews
{
    [super addOwnViews];
    
    _askMicBtn = [[ImageTitleButton alloc] initWithStyle:ETitleLeftImageRightCenter];
    _askMicBtn.layer.borderColor = kPurpleColor.CGColor;
    _askMicBtn.layer.borderWidth = 1.0;
    _askMicBtn.layer.cornerRadius = 5;
    [_askMicBtn addTarget:self action:@selector(askMicMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_askMicBtn];
    
    if (_liveController.isHost)
    {
        [_askMicBtn setTitle:@"邀请上麦" forState:UIControlStateNormal];
    }
    else
    {
        [_askMicBtn setTitle:@"请求上麦" forState:UIControlStateNormal];
    }
    
    _closeBtn = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    
    [kInteractAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)layoutOnIPhone
{
    [_askMicBtn sizeWith:CGSizeMake(80, 30)];
    [_askMicBtn alignParentTopWithMargin:kDefaultMargin];
    [_askMicBtn layoutParentHorizontalCenter];
    
    [_closeBtn sizeWith:CGSizeMake(30, 30)];
    [_closeBtn alignParentTop];
    [_closeBtn alignParentRight];
}

- (void)onClose
{
    [_liveController alertExitLive];
}

- (void)askMicMessage:(ImageTitleButton *)button
{
    if (_liveController.isHost)
    {
        //是主播则邀请上麦
        [_askMicBtn setTitle:@"取消邀请" forState:UIControlStateNormal];
        [self inviteMic];
    }
    else
    {
        //是观众则请求上麦
        [self requestMic];
    }
}

- (void)inviteMic
{
    [(MultiAVIMMsgHandler *)_msgHandler syncRoomOnlineUser:32 members:^(NSArray *members) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (members.count > 0)
            {
                id<AVMultiUserAble> user = members[0];
                
                TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
                if ([controller.multiManager isInteractUser:user])
                {
                    [_askMicBtn setTitle:@"邀请上麦" forState:UIControlStateNormal];
                    [controller.multiManager initiativeCancelInteractUser:user];
                }
                else
                {
                    [controller.multiManager inviteUserJoinInteraction:user];
                }
            }
        });
    } fail:nil];
}

- (void)requestMic
{
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;

    if ([controller.multiManager isInteractUser:(id<IMUserAble>)[IMAPlatform sharedInstance].host])
    {
        [_askMicBtn setTitle:@"请求上麦" forState:UIControlStateNormal];
        [controller.multiManager initiativeCancelInteractUser:(id<AVMultiUserAble>)[IMAPlatform sharedInstance].host];
    }
    else
    {
        TCSoVAInteractMsgHandler *soMsgHandler = (TCSoVAInteractMsgHandler *)_msgHandler;
        [soMsgHandler sendAskMicMessage];
    }
}

//互邀上麦S_7:重写接收自定义消息函数
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
            [_askMicBtn setTitle:@"挂断" forState:UIControlStateNormal];
            [self onRecvHostInteractChangeAuthAndRole:msg];
        }
            break;
            //主播拒绝连麦，观众端做相应处理
        case TCSoMsgType_RefuseViewersAskMic:
        {
            [self refuseViewersAskMic:msg];
        }
            break;
            //观众加入互动
        case AVIMCMD_Multi_Interact_Join:
        {
            [_askMicBtn setTitle:@"挂断" forState:UIControlStateNormal];
            [self onRecvReplyInteractJoin:msg];
        }
            break;
            //主播邀请连麦
        case AVIMCMD_Multi_Host_Invite:
            [self onRecvHostInteract:msg];
            break;
            //观众拒绝连麦
        case AVIMCMD_Multi_Interact_Refuse:
            [self onRecvReplyInteractRefuse:msg];
            break;
            
        default:
            break;
    }
}

//互邀上麦S_8:重写接收群自定义消息函数，这里主要是处理取消互动消息(取消互动消息无论是观众还是主播都可以发送)
- (void)onIMHandler:(AVIMMsgHandler *)receiver recvCustomGroupMultiMsg:(AVIMCMD *)msg
{
    NSInteger type = [msg msgType];
    switch (type)
    {
        case AVIMCMD_Multi_CancelInteract:
        {
            [self onRecvCancelInteract:msg];
        }
            break;
        default:
            break;
    }
}

- (void)onRecvHostInteract:(AVIMCMD *)msg
{
    id<IMUserAble> sender = [msg sender];
    
    __weak VAInteractMicUIViewController *ws = self;
    __weak MultiAVIMMsgHandler *wm = (MultiAVIMMsgHandler *)_msgHandler;
    NSString *text = [NSString stringWithFormat:@"主播(%@)邀请您参加TA的互动直播", [sender imUserName]];
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"互动直播邀请" message:text cancelButtonTitle:@"拒绝" otherButtonTitles:@[@"同意"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0)
        {
            if (!kRectHostCancelInteract)
            {
                //  拒绝
                [wm sendC2CAction:AVIMCMD_Multi_Interact_Refuse to:sender succ:nil fail:nil];
            }
            
        }
        else if (buttonIndex == 1)
        {
            if (!kRectHostCancelInteract)
            {
                [ws onRecvHostInteractChangeAuthAndRole:msg];
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            kInteractAlert = nil;
            kRectHostCancelInteract = NO;
        });
    }];
    alert.tag = 2000;
    [alert show];
    kInteractAlert = alert;
}

- (void)onRecvHostInteractChangeAuthAndRole:(AVIMCMD *)msg
{
    id<IMUserAble> sender = [msg sender];
    // 本地先修改权限
    //  controller.multiManager ;
    // 然后修改role
    // 再打开相机
    __weak VAInteractMicUIViewController *ws = self;
    __weak MultiAVIMMsgHandler *wm = (MultiAVIMMsgHandler *)_msgHandler;
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    
    // 检查本地硬件(Mic与相机权限)
    [controller checkPermission:^{
        // 本地没有权限，回复拒绝
        [wm sendC2CAction:AVIMCMD_Multi_Interact_Refuse to:sender succ:nil fail:nil];
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
                    [wm sendC2CAction:AVIMCMD_Multi_Interact_Refuse to:sender succ:nil fail:nil];
                    DebugLog(@"code = %d, msg = %@", code, msg);
                }];
            }
            else
            {
                [wm sendC2CAction:AVIMCMD_Multi_Interact_Refuse to:sender succ:nil fail:nil];
            }
        }];
    }];
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


- (void)showSelfVideoToOther
{
    [_askMicBtn setTitle:@"挂断" forState:UIControlStateNormal];
    
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

- (void)onRecvReplyInteractRefuse:(AVIMCMD *)msg
{
    // 移除画面
    // 取消请求
    id<AVMultiUserAble> sender = (id<AVMultiUserAble>)msg.sender;
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    [controller.multiManager forcedCancelInteractUser:sender];
    
}

- (void)assignWindowResourceTo:(id<AVMultiUserAble>)user isInvite:(BOOL)inviteOrAuto
{
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat screenW = screen.size.width;
    CGFloat screenH = screen.size.height;
    [user setAvInteractArea:CGRectMake(screenW-100, (screenH-120)/2, 100, 120)];
}


- (void)onRecvCancelInteract:(AVIMCMD *)msg
{
    if (_liveController.isHost)
    {
        [_askMicBtn setTitle:@"邀请上麦" forState:UIControlStateNormal];
    }
    else
    {
        [_askMicBtn setTitle:@"请求上麦" forState:UIControlStateNormal];
    }
    
    id<AVMultiUserAble> sender = (id<AVMultiUserAble>)[msg sender];
    
    if (kInteractAlert)
    {
        kRectHostCancelInteract = YES;
        [kInteractAlert dismissWithClickedButtonIndex:0 animated:YES];
        [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@ 已取消与您的互动",[sender imUserName]]];
        return;
    }
    
    NSString *operUserId = [msg actionParam];
    
    TCAVMultiLiveViewController *mvc = (TCAVMultiLiveViewController *)_liveController;
    TCAVIMMIManager *mgr = mvc.multiManager;
    
    id<AVMultiUserAble> user = [mgr interactUserOfID:operUserId];
    
    if ([mgr isMainUserByID:operUserId])
    {
        // 主屏用户时，检查是显示leave界面
        [mvc.livePreview hiddenLeaveView];
    }
    
    if (user)
    {
        [mgr forcedCancelInteractUser:user];
    }
}


@end


@implementation TCSoVAInteractMsgHandler

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

//发送请求上麦消息
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
