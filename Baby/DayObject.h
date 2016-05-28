//
//  DayObject.h
//  Baby
//
//  Created by luan on 16/5/26.
//  Copyright © 2016年 luan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HourObject.h"

@interface DayObject : NSObject <NSCopying,NSCoding>

-(NSArray *)hours;
-(void)addHour:(HourObject *)item;
-(void)removeHour:(HourObject *)item;

@property(assign,nonatomic)NSString *day;

@end
