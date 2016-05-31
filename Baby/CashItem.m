//
//  CashItem.m
//  Baby
//
//  Created by luan on 16/5/31.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "CashItem.h"

static NSString * const kItemKey = @"kItemKey";
static NSString * const kCostKey = @"kCostKey";


@implementation CashItem

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.itemString = [aDecoder decodeObjectForKey:kItemKey];
        self.cost = [aDecoder decodeFloatForKey:kCostKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder; {
    [aCoder encodeObject:self.itemString forKey:kItemKey];
    [aCoder encodeFloat:self.cost forKey:kCostKey];
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone; {
    CashItem *copy = [[[self class] allocWithZone:zone] init];
    copy.itemString = [self.itemString copyWithZone:zone];
    copy.cost = self.cost;
    
    return copy;
}


@end
