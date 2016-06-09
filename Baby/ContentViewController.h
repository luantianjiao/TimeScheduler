//
//  ContentViewController.h
//  Baby
//
//  Created by luan on 16/5/24.
//  Copyright © 2016年 luan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HourObject.h"

@interface ContentViewController : UIViewController <UIPickerViewDelegate,UITextFieldDelegate,UIPickerViewDataSource>

@property(assign,nonatomic)NSInteger detailItem;

@end
