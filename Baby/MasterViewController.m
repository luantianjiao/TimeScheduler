//
//  MasterViewController.m
//  Baby
//
//  Created by luan on 16/5/23.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "MasterViewController.h"
#import "DayMasterViewController.h"
#import "DayObject.h"


@interface MasterViewController ()

@property NSArray *objects;
@property NSArray *weekdays;
@property NSInteger today;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.objects = @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    self.weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    
    self.today = [self weekdayStringFromDate:[NSDate date]];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (DayMasterViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (NSArray *)detailDates:(NSInteger)today{
    NSArray *results;
    if (today == 1) {
        //星期日
    }
    
    
    return results;
}

- (NSInteger)weekdayStringFromDate:(NSDate*)inputDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
//    return [weekdays objectAtIndex:theComponents.weekday];
    return theComponents.weekday;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = self.objects[indexPath.row];
        
        DayObject *day = [[DayObject alloc]init];
        [day setDay:object];
        
        DayMasterViewController *controller = (DayMasterViewController *)[[segue destinationViewController] topViewController];
//        NSInteger object = indexPath.row;
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSString *object = self.objects[indexPath.row];
    
    cell.textLabel.text = object;
    
    if ((indexPath.row + 1) == self.today) {
        cell.textLabel.backgroundColor = [UIColor clearColor];
        UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
        backgrdView.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.7 alpha:0.5];
        cell.backgroundView = backgrdView;
        
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy MM dd"];
        cell.detailTextLabel.text = [format stringFromDate:[NSDate date]];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
