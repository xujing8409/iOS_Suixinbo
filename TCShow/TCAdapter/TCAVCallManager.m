//
//  TCAVCallManager.m
//  TIMChat
//
//  Created by AlexiChen on 16/6/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//
#if kSupportCallScene
#import "TCAVCallManager.h"

@implementation TCAVCallManager

// 将用户添加并显示
// 如果当
- (void)addRenderAndRequest:(NSArray *)imusers
{
    if (imusers.count)
    {
        
        // main已赋值时，不能再处理
        if (!_mainUser)
        {
            id<AVMultiUserAble> user = imusers[0];
            BOOL hasAdd = [self addInteractUser:user];
            
            if (hasAdd)
            {
                _mainUser = user;
                
                // 设置界面相关
                [_mainUser setAvInvisibleInteractView:nil];
                [_mainUser setAvInteractArea:[_preview bounds]];
                [_preview addRenderFor:_mainUser];
                
            }
            
        }
        
        [self requestMultipleViewOf:imusers];
    }
    
    
}

@end
#endif