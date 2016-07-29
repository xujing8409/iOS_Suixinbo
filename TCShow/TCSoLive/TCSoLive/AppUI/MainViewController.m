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
    TCSoLiveItem *item = [[TCSoLiveItem alloc] initWithTitle:@"送花示例" icon:nil action:^(id<MenuAbleItem> menu) {
        
        LiveParamViewController *vc = [[LiveParamViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    item.funDesc = @"集成随心播TCAdapter，实现送花自定义消息，以及送花动画演示";
    [_data addObject:item];
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
