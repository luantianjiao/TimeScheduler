//
//  DayObject.m
//  Baby
//
//  Created by luan on 16/5/26.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "DayObject.h"

static NSString * const kHoursKey = @"kHoursKey";
static NSString * const kMoneyKey = @"kMoneyKey";



@interface DayObject()

@property(copy,nonatomic)NSMutableArray *hours;
@property(copy,nonatomic)NSArray *moneyArray;


@end

@implementation DayObject

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.hours = [aDecoder decodeObjectForKey:kHoursKey];
        self.moneyArray = [aDecoder decodeObjectForKey:kMoneyKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder; {
    [aCoder encodeObject:self.hours forKey:kHoursKey];
    [aCoder encodeObject:self.moneyArray forKey:kMoneyKey];
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone; {
    DayObject *copy = [[[self class] allocWithZone:zone] init];
    NSMutableArray *hoursCopy = [NSMutableArray array];
    for (id hour in self.hours) {
        [hoursCopy addObject:[hour copyWithZone:zone]];
    }
    
    NSMutableArray *moneyArrayCopy = [[NSMutableArray alloc]init];
    for (id money in self.moneyArray) {
        [moneyArrayCopy addObject:[money copyWithZone:zone]];
    }
    
    copy.hours = hoursCopy;
    copy.moneyArray = moneyArrayCopy;
    
    return copy;
}

@end
