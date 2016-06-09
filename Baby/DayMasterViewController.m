//
//  MasterViewController.m
//  test2
//
//  Created by luan on 16/5/27.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "DayMasterViewController.h"
#import "ContentViewController.h"
#import "CashViewController.h"
#import "KxMenu.h"
#import <FMDB.h>


@interface DayMasterViewController ()

@property(strong,nonatomic)NSMutableArray *objects;
@property(strong,nonatomic)NSArray *constObjects;
@property(assign,nonatomic)NSInteger index;
@property(strong,nonatomic)NSMutableArray *toAddObjects;

@property(strong,nonatomic)NSArray *temparray;


@end

@implementation DayMasterViewController

FMDatabase *dataBase;

-(void)setDayId:(NSInteger)dayId{
    if (_dayId != dayId) {
        _dayId = dayId;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"day master view controller");
    // Do any additional setup after loading the view, typically from a nib.
    
        
    //end of database

    
    self.index = 0;
    self.constObjects = @[@"7:00-8:00",@"8:00-9:00",@"9:00-10:00",@"10:00-11:00",@"11:00-12:00",@"12:00-13:00",@"13:00-14:00",@"14:00-15:00",@"15:00-16:00",@"16:00-17:00",@"17:00-18:00",@"18:00-19:00",@"19:00-20:00",@"20:00-21:00",@"21:00-22:00"];
    
    
    //get dayString throught dayId
    //database
    NSString *dbPath = [self dataFilePath];
    dataBase = [FMDatabase databaseWithPath:dbPath] ;
    if (![dataBase open]) {
        NSLog(@"Could not open db.");
        return ;
    }

    NSString * sql=[NSString stringWithFormat:@"select * from day where id = %ld",self.dayId];
    FMResultSet *result=[dataBase executeQuery:sql];
    NSString * name;
    
    while(result.next){
        name =[result stringForColumn:@"name"];
    }
    
    self.title = name;
    
    if (!self.toAddObjects) {
        self.toAddObjects = [[NSMutableArray alloc]initWithArray:self.constObjects];
    }else{
        [self.toAddObjects removeAllObjects];
        [self.toAddObjects addObjectsFromArray:self.constObjects];
    }
    
    if ([self.objects count]>0) {
        for (NSString *hour in self.objects) {
            if([self.toAddObjects containsObject:hour]){
                [self.toAddObjects removeObject:hour];
            }
        }
    }
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenu:)];
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
    [cashController setDayId:self.dayId];

    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:cashController];
    
    [self presentViewController:navController animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
    
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    NSString * sql=[NSString stringWithFormat:@"select * from hourItem where dayId = %ld",(long)self.dayId];
    FMResultSet *result=[dataBase executeQuery:sql];
    while(result.next){
        NSString *hourString =[result stringForColumn:@"hour"];
        [self.objects addObject:hourString];
    }
 }

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    return dbPath;
}

- (void)showMenu:(UIButton *)sender
{
    NSMutableArray *menuItems = [[NSMutableArray alloc]init];
    
    KxMenuItem *menuItem = [KxMenuItem menuItem:@"时间段"
                                          image:nil
                                         target:nil
                                         action:nil];
    
    [menuItems addObject:menuItem];

    
    for (NSString *menuString in self.toAddObjects) {
        KxMenuItem *menuItem = [KxMenuItem menuItem:menuString
                       image:nil
                      target:self
                    action:@selector(pushMenuItem:)];
        
        [menuItems addObject:menuItem];
    }
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    const CGFloat W = self.view.bounds.size.width;
//    const CGFloat H = self.view.bounds.size.height;
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(W - 105, 15, 100, 50)
                 menuItems:menuItems];
}

- (void) pushMenuItem:(KxMenuItem*)sender
{
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    NSString * createHourItem = @"create table if not exists hourItem(id integer primary key autoincrement,hour text,type text,content text,isDone integer,dayId integer)";
    
    BOOL c3= [dataBase executeUpdate:createHourItem];
    if (c3) {
        NSLog(@"Hour Item表创建成功.");
    }
    
    NSString * insertSqlHour=@"insert into hourItem(hour,type,content,isDone,dayId) values(?,?,?,?,?)";
    bool inflag1=[dataBase executeUpdate:insertSqlHour,sender.title,@"Running",@"It is a beautiful day.",@(NO),@(self.dayId)];
    if (inflag1) {
        NSLog(@"insert successfully!");
    }
    
    [self.objects insertObject:sender.title atIndex:self.index];
    [self.toAddObjects removeObject:sender.title];
    
    self.index += 1;
    
    NSArray *tempArray = [[NSArray alloc]initWithArray:self.objects];
    
    tempArray = [(NSArray *)self.objects sortedArrayUsingComparator:^(id obj1, id obj2){
        
        NSString *hour1String = (NSString *)obj1;
        NSString *hour2String = (NSString *)obj2;

        if ([hour1String integerValue] > [hour2String integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([hour1String integerValue] < [hour2String integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [self.objects removeAllObjects];
    [self.objects addObjectsFromArray:tempArray];
    
    [self.tableView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showContent"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSString *hour = (NSString *)self.objects[indexPath.row];
        
        NSString * sql=[NSString stringWithFormat:@"select id from hourItem where hour = '%@'",hour];
        FMResultSet *result=[dataBase executeQuery:sql];
        int ids = 0;
        
        while(result.next){
            ids=[result intForColumn:@"id"];
            NSLog(@"%d",ids);
        }
        
        ContentViewController *controller = (ContentViewController *)[segue destinationViewController];
        [controller setDetailItem:ids];
        
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
    NSString *hour = (NSString *)self.objects[indexPath.row];
    
    //根据hour从数据库中hourItem的id
//    NSString *object = hour.hour;
    cell.textLabel.text = hour;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *hour = (NSString *)self.objects[indexPath.row];
        [self.objects removeObjectAtIndex:indexPath.row];
        
        NSString * sql=[NSString stringWithFormat:@"select id from hourItem where hour = '%@'",hour];
        FMResultSet *result=[dataBase executeQuery:sql];
        int ids = 0;
        
        while(result.next){
            ids=[result intForColumn:@"id"];
            NSLog(@"%d",ids);
        }

        //删除数据
        NSString * deleteSQL=[NSString stringWithFormat:@"delete from hourItem where id = %ld",(long)ids];
        
        BOOL res = [dataBase executeUpdate:deleteSQL];
        if (!res) {
            NSLog(@"error when delete item");
        } else {
            NSLog(@"success to delete item");
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
