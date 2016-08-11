//
//  MainViewController.m
//  TCSoLive
//
//  Created by wilderliao on 16/7/28.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "MainViewController.h"

@interface TCSoLiveItem : MenuItem

@property (nonatomic , copy) NSString *funDesc;
@end

@implementation TCSoLiveItem
@end

@implementation MainViewController

- (void)configOwnViews
{
    _data = [NSMutableArray array];
    
    //将参数输入界面添加到主界面列表中
    TCSoLiveItem *item = [[TCSoLiveItem alloc] initWithTitle:@"EX1:送花示例" icon:nil action:^(id<MenuAbleItem> menu) {
        
        LiveParamViewController *vc = [[LiveParamViewController alloc] init];
        [vc configDemoType:DemoType_SendFlower];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    item.funDesc = @"实现送花自定义消息，以及送花动画演示";
    [_data addObject:item];
    
    TCSoLiveItem *item1 = [[TCSoLiveItem alloc] initWithTitle:@"EX2:观众邀请上麦" icon:nil action:^(id<MenuAbleItem> menu) {
        LiveParamViewController *vc = [[LiveParamViewController alloc] init];
        [vc configDemoType:DemoType_ViewersInviteAnchor];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    item1.funDesc = @"演示观众邀请主播上麦及自定义消息的实现";
    [_data addObject:item1];
    
    TCSoLiveItem *item2 = [[TCSoLiveItem alloc] initWithTitle:@"EX3:观众和主播上麦互动" icon:nil action:^(id<MenuAbleItem> menu) {
        LiveParamViewController *vc = [[LiveParamViewController alloc] init];
        [vc configDemoType:DemoType_VAInteractMic];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    item2.funDesc = @"观众可请求上麦，主播可邀请上麦";
    [_data addObject:item2];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kTCSoLiveCellIdentifier"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"kTCSoLiveCellIdentifier"];
    }
    
    TCSoLiveItem *kv = _data[indexPath.row];
    cell.textLabel.text = [kv title];
    cell.detailTextLabel.text = [kv funDesc];
    return cell;
}

@end
