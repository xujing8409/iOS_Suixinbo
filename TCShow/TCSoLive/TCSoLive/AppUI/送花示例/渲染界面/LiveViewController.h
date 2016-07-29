//
//  LiveViewController.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "TCAVLiveViewController.h"
/**
 *  集成S_4:集成直播渲染界面，需集成TCAVLiveViewController，这里是画面的渲染工作，不包括交互界面，交互界面是在本界面上再添加一层视图，在本demo中是LiveUIViewController
 */
@interface LiveViewController : TCAVLiveViewController
{
#if kSupportIMMsgCache
    NSInteger           _uiRefreshCount;
#endif
}

#if kSupportIMMsgCache
- (void)renderUIByAVSDK;
#endif
@end
