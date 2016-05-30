//
//  MasterViewController.m
//  test2
//
//  Created by luan on 16/5/27.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "DayMasterViewController.h"
#import "ContentViewController.h"
#import "HourObject.h"
#import "CashViewController.h"

static NSString * const kRootKey = @"kRootKey";

@interface DayMasterViewController ()

@property(strong,nonatomic)NSMutableArray *objects;
@property(strong,nonatomic)NSArray *constObjects;
@property(assign,nonatomic)NSInteger index;

@end

@implementation DayMasterViewController

-(void)setDetailItem:(DayObject *)newDetailItem{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
//        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.index = 0;
    self.constObjects = @[@"7:00-8:00",@"8:00-9:00",@"9:00-10:00",@"10:00-11:00",@"11:00-12:00",@"12:00-13:00",@"13:00-14:00",@"14:00-15:00",@"15:00-16:00",@"16:00-17:00",@"17:00-18:00",@"18:00-19:00",@"19:00-20:00",@"20:00-21:00",@"21:00-22:00"];

    
    self.title = self.detailItem.day;
//    self.navigationItem.title = self.detailItem.day;
    
    //get achive
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if (!self.objects) {
            self.objects = [[NSMutableArray alloc] init];
        }

        NSData *data = [[NSMutableData alloc]
                        initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        self.objects = [unarchiver decodeObjectForKey:kRootKey];
        [unarchiver finishDecoding];
    }
    

    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.contentViewController = (ContentViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //swipe
    for (NSUInteger touchCount = 1; touchCount <= 5; touchCount++) {
        UISwipeGestureRecognizer *horizontal;
        horizontal = [[UISwipeGestureRecognizer alloc]
                      initWithTarget:self action:@selector(reportHorizontalSwipe)];
        horizontal.direction = UISwipeGestureRecognizerDirectionLeft |
        UISwipeGestureRecognizerDirectionRight;
        horizontal.numberOfTouchesRequired = touchCount;
        [self.view addGestureRecognizer:horizontal];
    }

}

-(void)reportHorizontalSwipe{
    CashViewController *cashController = [[CashViewController alloc]init];
    [cashController setDetailItem:self.detailItem];
    [self presentViewController:cashController animated:YES completion:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"day master view controller disappear");

    [super viewWillDisappear:animated];
    NSString *filePath = [self dataFilePath];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:self.objects forKey:kRootKey];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive",
                                                               self.detailItem.day]];
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
//    [self.objects insertObject:self.constObjects[self.index] atIndex:self.index];
    
    HourObject *hour = [[HourObject alloc]init];
    [hour setHour:self.constObjects[self.index]];
    [hour setType:@"Running"];
    [hour setIsDone:NO];
    [hour setContent:@"It is a beautiful day."];
    
    [self.objects insertObject:hour atIndex:self.index];
    
    self.index += 1;
    
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showContent"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        HourObject *hour = (HourObject *)self.objects[indexPath.row];
        
        ContentViewController *controller = (ContentViewController *)[segue destinationViewController];
        [controller setDetailItem:hour];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    HourObject *hour = (HourObject *)self.objects[indexPath.row];
    NSString *object = hour.hour;
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
