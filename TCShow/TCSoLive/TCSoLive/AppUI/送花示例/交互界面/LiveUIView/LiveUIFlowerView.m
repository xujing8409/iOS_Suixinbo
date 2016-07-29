//
//  LiveUIFlowerView.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/25.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "LiveUIFlowerView.h"

@interface LiveUIFlowerView ()
{
    BOOL _isRightMoveAnimationRunning;//右移动画
    BOOL _isGradualAnimationRunning;//渐变动画
}
@end

@implementation LiveUIFlowerView

- (instancetype)init
{
    if ([super init])
    {
        _isRightMoveAnimationRunning = NO;
        _isGradualAnimationRunning = NO;
        _flowerCount = 0;
    }
    return self;
}

- (void)addOwnViews
{
    _flowerShowBtn = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightLeft];
    _flowerShowBtn.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    _flowerShowBtn.userInteractionEnabled = YES;
    _flowerShowBtn.layer.cornerRadius = 12;
    _flowerShowBtn.layer.masksToBounds = YES;

    [_flowerShowBtn setTitle:@"🌹 x0" forState:UIControlStateNormal];
    [self addSubview:_flowerShowBtn];
}

- (void)layoutSubviews
{
    [_flowerShowBtn sizeWith:CGSizeMake(100, 30)];
    [_flowerShowBtn alignParentCenter];
}

- (void)startAnimation
{
    _flowerCount++;
    [_flowerShowBtn setTitle:[NSString stringWithFormat:@"  🌹   x%ld",(long)_flowerCount] forState:UIControlStateNormal];
    //右移过程中不许做任何事情
    if (!_isRightMoveAnimationRunning)
    {
        //既没有右移动画，也没有渐变动画，则开启右移动画，并接着开启渐变动画
        if (!_isGradualAnimationRunning)
        {
            CGPoint beginCenter = self.center;
            CGPoint endCenter = CGPointMake(beginCenter.x+self.bounds.size.width, beginCenter.y);
            
            [UIView animateWithDuration:0.5 animations:^{
                _isRightMoveAnimationRunning = YES;
                self.center = endCenter;
            } completion:^(BOOL finished) {
                _isRightMoveAnimationRunning = NO;
                //右移动画结束，开始渐变动画
                [UIView animateWithDuration:3.0 delay:2.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    _isGradualAnimationRunning = YES;
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    
                    NSLog(@"************ if finished = %d", finished);
                    if (!finished)
                    {
                        return ;
                    }
                    
                    _isGradualAnimationRunning = NO;
                    self.alpha = 1;
                    self.center = beginCenter;
                    _flowerCount = 0;
                    
                }];
            }];
        }
        //没有右移动画，正在渐变动画，则停止当前渐变动画，开启新的渐变动画
        else
        {
            //移除当前动画
            
            [self.layer removeAllAnimations];
            
            self.alpha = 1;
            
            CGPoint curCenter = self.center;
            CGPoint beginCenter = CGPointMake(curCenter.x-self.bounds.size.width, curCenter.y);
            
            //重新添加新的渐变动画
            [UIView animateWithDuration:3.0 delay:2.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                _isGradualAnimationRunning = YES;
                self.alpha = 0;
            } completion:^(BOOL finished) {
                
                NSLog(@"************ else finished = %d", finished);
                if (!finished)
                {
                    return ;
                }
                _isGradualAnimationRunning = NO;
                self.alpha = 1;
                self.center = beginCenter;
                _flowerCount = 0;
                
            }];
        }
    }
}
@end
