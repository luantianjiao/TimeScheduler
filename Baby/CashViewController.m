//
//  CashViewController.m
//  Baby
//
//  Created by luan on 16/5/29.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "CashViewController.h"
#import "Masonry.h"
#import <STPopup/STPopup.h>
#import "CashPopUpViewController.h"
#import <FMDB.h>
#import "CashItem.h"

@interface CashViewController ()

@property(strong,nonatomic)NSMutableArray *objects;

@end

@implementation CashViewController

FMDatabase *dataBaseCashView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doRefresh:) name:@"RefreshTableNotification" object:nil];

    
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor blueColor];
    NSLog(@"cash view controller");
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CashCell"];
    
    NSString *dbPath = [self dataFilePath];
    dataBaseCashView = [FMDatabase databaseWithPath:dbPath] ;
    
    if (![dataBaseCashView open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    NSString * sql=[NSString stringWithFormat:@"select * from cashItem where dayId = %ld",(long)self.dayId];
    FMResultSet *result=[dataBaseCashView executeQuery:sql];
    
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc]init];
    }
    
    while(result.next){
        CashItem *cashItem = [[CashItem alloc]init];
        cashItem.cashId = [result intForColumn:@"id"];
        cashItem.itemString = [result stringForColumn:@"cashString"];
        cashItem.cost = [result doubleForColumn:@"cost"];
        [self.objects addObject:cashItem];
    }
    
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
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;

}

-(void)doRefresh:(NSNotification *)notification{
    NSString * sql=[NSString stringWithFormat:@"select * from cashItem where dayId = %ld",(long)self.dayId];
    FMResultSet *result=[dataBaseCashView executeQuery:sql];
    
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc]init];
    }else{
        [self.objects removeAllObjects];
    }
    
    while(result.next){
        CashItem *cashItem = [[CashItem alloc]init];
        cashItem.cashId = [result intForColumn:@"id"];
        cashItem.itemString = [result stringForColumn:@"cashString"];
        cashItem.cost = [result doubleForColumn:@"cost"];
        [self.objects addObject:cashItem];
    }

    [self.tableView reloadData];
}

-(void)insertNewObject:(UIButton *)button{
    
    NSString * createCashItem = @"create table if not exists cashItem(id integer primary key autoincrement,cashString text,cost double,dayId integer)";
    
    BOOL c3= [dataBaseCashView executeUpdate:createCashItem];
    if (c3) {
        NSLog(@"Cash Item表创建成功.");
    }
    
    NSString * insertSqlCash=@"insert into cashItem(cashString,cost,dayId) values(?,?,?)";
    bool inflag1=[dataBaseCashView executeUpdate:insertSqlCash,@"八宝粥",@(3.8),@(self.dayId)];
    if (inflag1) {
        NSLog(@"insert successfully!");
    }
    
    NSString *selectSQL = @"select max(id) as id from cashItem";
    FMResultSet *result=[dataBaseCashView executeQuery:selectSQL];
    int cashId = 0;
    while(result.next){
        cashId = [result intForColumn:@"id"];
    }

    CashPopUpViewController *cashPopUpVC = [[CashPopUpViewController alloc]init];
    cashPopUpVC.cashId = cashId;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:cashPopUpVC];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:self];
    
    [self.tableView reloadData];
}


-(void)reportHorizontalSwipe{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    return dbPath;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CashItem *cashItem = [[CashItem alloc]init];
    cashItem = self.objects[indexPath.row];
    
    CashPopUpViewController *cashPopUpVC = [[CashPopUpViewController alloc]init];
    cashPopUpVC.cashId = cashItem.cashId;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:cashPopUpVC];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:self];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CashCell"];

    
    CashItem *cash = (CashItem *)self.objects[indexPath.row];
    NSString *object = cash.itemString;
    cell.textLabel.text = object;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f",cash.cost];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CashItem *cashItem = [[CashItem alloc]init];
        cashItem = (CashItem *)self.objects[indexPath.row];
        [self.objects removeObjectAtIndex:indexPath.row];
        //删除数据
        NSString * deleteSQL=[NSString stringWithFormat:@"delete from cashItem where id = %ld",(long)cashItem.cashId];
        
        BOOL res = [dataBaseCashView executeUpdate:deleteSQL];
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
