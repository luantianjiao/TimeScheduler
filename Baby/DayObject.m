//
//  DayObject.m
//  Baby
//
//  Created by luan on 16/5/26.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "DayObject.h"

static NSString * const kLinesKey = @"kLinesKey";


@interface DayObject()

@property(copy,nonatomic)NSMutableArray *hours;


@end

@implementation DayObject

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.hours = [aDecoder decodeObjectForKey:kLinesKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder; {
    [aCoder encodeObject:self.hours forKey:kLinesKey];
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone; {
    DayObject *copy = [[[self class] allocWithZone:zone] init];
    NSMutableArray *hoursCopy = [NSMutableArray array];
    for (id hour in self.hours) {
        [hoursCopy addObject:[hour copyWithZone:zone]];
    }
    copy.hours = hoursCopy;
    return copy;
}


-(void)removeHour:(HourObject *)item{
    [_hours removeObject:item];
    [self saveFavorites];
}

-(void)addHour:(HourObject *)item{
    [_hours insertObject:item atIndex:0];
    [self saveFavorites];
}


- (NSString *)dataFilePath
{
    NSString *name = [NSString stringWithFormat:@"%@.archive",self.day];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:name];
}


-(void)saveFavorites{
    NSString *filePath = [self dataFilePath];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:self.hours forKey:kLinesKey];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

@end
