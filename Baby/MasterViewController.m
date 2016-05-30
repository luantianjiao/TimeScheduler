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
#import "NSDate+DateTools.h"


@interface MasterViewController ()

@property NSArray *objects;
@property NSMutableArray *days;
@property NSInteger today;

@property NSArray *weekdays;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.objects = @[@"Sunday", @"Monday", @"Tuesday", @"Wenesday", @"Thursday", @"Friday", @"Saturday"];
    self.weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
//    NSDate *date = [[NSDate date]dateBySubtractingDays:60];
    NSDate *date = [NSDate date];
    self.today = date.weekday;
    
    self.objects = [[NSMutableArray alloc]initWithArray:[self getDateWithYear:date.year Month:date.month Week:date.weekOfMonth]];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (DayMasterViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


- (NSArray *)getDateWithYear:(NSInteger )year Month:(NSInteger)month Week:(NSInteger)week{
    NSMutableArray *resultDateArr = [NSMutableArray array];
    NSDate * date = [NSDate dateWithYear:year month:month day:1];
//    date = [date dateByAddingDays:1];
//    NSInteger daysInMonth = date.daysInMonth + 1;
    for (NSInteger i = 0; i < date.daysInMonth; i++) {
        if (week == date.weekOfMonth) {
//            NSLog(@"%@", [date formattedDateWithStyle:NSDateFormatterMediumStyle]);
            [resultDateArr addObject:date];
        }
        date = [date dateByAddingDays:1];
    }
    return resultDateArr;
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = (NSDate *)self.objects[indexPath.row];
        
        DayObject *day = [[DayObject alloc]init];
        [day setDay:[object formattedDateWithStyle:NSDateFormatterMediumStyle]];
        
//        DayMasterViewController *controller = (DayMasterViewController *)[[[[[[segue destinationViewController] topViewController] childViewControllers] objectAtIndex:0] childViewControllers] objectAtIndex:0];
        DayMasterViewController *controller = (DayMasterViewController *)[[segue destinationViewController] topViewController];

//        NSInteger object = indexPath.row;
        [controller setDetailItem:day];
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
    
    NSDate *object = self.objects[indexPath.row];
    
    cell.textLabel.text = self.weekdays[object.weekday];
    cell.detailTextLabel.text = [object formattedDateWithFormat:@"dd MMM, yyyy"];

    
    if ((indexPath.row + 1) == self.today) {
        cell.textLabel.backgroundColor = [UIColor clearColor];
        UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
        backgrdView.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.7 alpha:0.5];
        cell.backgroundView = backgrdView;
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
