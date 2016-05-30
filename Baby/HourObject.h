//
//  HourObject.h
//  Baby
//
//  Created by luan on 16/5/26.
//  Copyright © 2016年 luan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HourObject : NSObject  <NSCopying,NSCoding>

@property(strong,nonatomic)NSString *hour;

@property(strong,nonatomic)NSString *type;
@property(strong,nonatomic)NSString *content;
@property(assign,nonatomic)BOOL isDone;

@end
