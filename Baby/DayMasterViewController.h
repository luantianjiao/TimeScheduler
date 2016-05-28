//
//  MasterViewController.h
//  test2
//
//  Created by luan on 16/5/27.
//  Copyright © 2016年 luan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentViewController;

@interface DayMasterViewController : UITableViewController

@property(strong,nonatomic)ContentViewController *contentViewController;
@property (strong, nonatomic) NSString *detailItem;

@end

