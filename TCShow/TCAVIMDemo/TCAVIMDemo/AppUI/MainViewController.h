//
//  MainViewController.h
//  TCAVIntergrateDemo
//
//  Created by AlexiChen on 16/5/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MenuTableViewController.h"

@interface TCMenuItem : MenuItem

@property (nonatomic, copy) NSString *funcDesc;

@end

@interface MainViewController : MenuTableViewController

@end
