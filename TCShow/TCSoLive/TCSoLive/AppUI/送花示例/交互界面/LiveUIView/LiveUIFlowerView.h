//
//  LiveUIFlowerView.h
//  TCSoLive
//
//  Created by wilderliao on 16/7/25.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  收到送花，动画显示视图。收到花之后的5s内，动画渐变消失，如果在5S内再次收到花，则动画重新开始计时
 */
@interface LiveUIFlowerView : UIView
{
@protected
    ImageTitleButton     *_flowerShowBtn;
    
    NSInteger           _flowerCount;//动画时间内收到的花数量
}

@property (nonatomic, strong) ImageTitleButton   *flowerShowBtn;

- (void)startAnimation;
@end
