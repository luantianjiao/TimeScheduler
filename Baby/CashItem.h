//
//  CashItem.h
//  Baby
//
//  Created by luan on 16/5/31.
//  Copyright © 2016年 luan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CashItem : NSObject

@property(assign,nonatomic)int cashId;
@property(strong,nonatomic)NSString *itemString;
@property(assign,nonatomic)float cost;

@end
