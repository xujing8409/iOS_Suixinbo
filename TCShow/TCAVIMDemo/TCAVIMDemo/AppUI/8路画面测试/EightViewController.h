//
//  EightViewController.h
//  TCAVIMDemo
//
//  Created by AlexiChen on 16/7/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#if kIsInnerTest
#import <UIKit/UIKit.h>
@interface GridPreview : TCAVMultiLivePreview

// 九宫格画面显示
@property (nonatomic, strong) NSMutableDictionary *renderMap;

@end

@interface EightRoomEngine : TCAVCallRoomEngine

@end

@interface EightViewController : TCAVMultiLiveViewController

@end
#endif