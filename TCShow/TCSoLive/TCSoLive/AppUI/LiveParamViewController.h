//
//  LiveParamViewController.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  集成S_3:登录成功后会跳转到TabBarController，MainViewController是tabar里面的控制器，直接跳转到MainViewController，这里可以放一些控件，以便输入必要的参数
    到本步骤，已经完成整个登录过程的集成
 */
@interface LiveParamViewController : BaseViewController
{
@protected
    ImageTitleButton *_joinButton;
    
    ImageTitleButton *_exitButton;
}

@property (nonatomic, strong) UITextField *avRoomId;

@property (nonatomic, strong) UITextField *groupId;

@property (nonatomic, strong) UITextField *hostId;

@end
