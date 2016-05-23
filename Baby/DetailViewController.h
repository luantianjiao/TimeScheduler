//
//  DetailViewController.h
//  Baby
//
//  Created by luan on 16/5/23.
//  Copyright © 2016年 luan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

