//
//  HourObject.m
//  Baby
//
//  Created by luan on 16/5/26.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "HourObject.h"

static NSString * const kHourKey = @"kHourKey";
static NSString * const kTypeKey = @"kTypeKey";
static NSString * const kContentKey = @"kContentKey";
static NSString * const kIsDoneKey = @"kIsDoneKey";

@implementation HourObject

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.hour = [aDecoder decodeObjectForKey:kHourKey];
        self.type = [aDecoder decodeObjectForKey:kTypeKey];
        self.content = [aDecoder decodeObjectForKey:kContentKey];
        self.isDone = [aDecoder decodeBoolForKey:kIsDoneKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder; {
    [aCoder encodeObject:self.hour forKey:kHourKey];
    [aCoder encodeObject:self.type forKey:kTypeKey];
    [aCoder encodeObject:self.content forKey:kContentKey];
    [aCoder encodeBool:self.isDone forKey:kIsDoneKey];
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone; {
    HourObject *copy = [[[self class] allocWithZone:zone] init];
//    NSMutableArray *hoursCopy = [NSMutableArray array];
//    for (id hour in self.hours) {
//        [hoursCopy addObject:[hour copyWithZone:zone]];
//    }
    copy.hour = [self.hour copyWithZone:zone];
    copy.type = [self.type copyWithZone:zone];
    copy.content = [self.content copyWithZone:zone];
    copy.isDone = self.isDone;
    
    return copy;
}


@end
