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
#import "CashItem.h"

static NSString * const kCashKey = @"kCashKey";

@interface CashViewController ()

@property(strong,nonatomic)NSMutableArray *objects;

@end

@implementation CashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor blueColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([self.detailItem.moneyArray count] > 0) {
        if (!self.objects) {
            self.objects = [[NSMutableArray alloc]initWithArray:self.detailItem.moneyArray];
        }else{
            [self.objects removeAllObjects];
            [self.objects addObjectsFromArray:self.detailItem.moneyArray];
        }
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

-(void)insertNewObject:(UIButton *)button{
    
    CashPopUpViewController *cashPopUpVC = [[CashPopUpViewController alloc]init];
    cashPopUpVC.objects = self.objects;
    
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
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive",
                                                               self.detailItem.day]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if (!self.objects) {
            self.objects = [[NSMutableArray alloc] init];
        }
        
        NSData *data = [[NSMutableData alloc]
                        initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        self.objects = [unarchiver decodeObjectForKey:kCashKey];
        [unarchiver finishDecoding];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
        
    NSString *filePath = [self dataFilePath];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:self.objects forKey:kCashKey];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
    
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
    
    
    CashItem *cash = (CashItem *)self.objects[indexPath.row];
    NSString *object = cash.itemString;
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
