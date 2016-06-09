//
//  CashPopUpViewController.m
//  Baby
//
//  Created by luan on 16/5/31.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "CashPopUpViewController.h"
#import <STPopup/STPopup.h>
#import "Masonry.h"
#import "CashItem.h"
#import <FMDB.h>



@interface CashPopUpViewController ()

@property(strong,nonatomic) UILabel *contentLabel;
@property(strong,nonatomic) UITextField *contentField;

@property(strong,nonatomic) UILabel *cashLabel;
@property(strong,nonatomic) UITextField *cashField;

//@property(copy,nonatomic) NSMutableArray *objects;


@end

@implementation CashPopUpViewController

FMDatabase *cashItemdb;

-(void)setCashId:(NSInteger)cashId{
    if (_cashId != cashId) {
        _cashId = cashId;
    }
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    return dbPath;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"Cash";
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = @"花费项目";
        [self.view addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UILabel *)cashLabel{
    if (!_cashLabel) {
        _cashLabel = [[UILabel alloc]init];
        _cashLabel.text = @"价格";
        [self.view addSubview:_cashLabel];
    }
    return _cashLabel;
}

-(UITextField *)contentField{
    if (!_contentField) {
        _contentField = [[UITextField  alloc]init];
        _contentField.placeholder = @"八宝粥";
//        _contentField.text = @"八宝粥";
        [self.view addSubview:_contentField];
    }
    return _contentField;
}

-(UITextField *)cashField{
    if (!_cashField) {
        _cashField = [[UITextField alloc]init];
        _cashField.keyboardType = UIKeyboardTypeNumberPad;
        _cashField.placeholder = @"3.2";
//        _cashField.text = @"3.2";
        [self.view addSubview:_cashField];
    }
    return _cashField;
}

-(void)configureView{
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(50);
        make.left.mas_equalTo(self.view).with.offset(30);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
    }];
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(50);
        make.left.mas_equalTo(self.contentLabel.mas_right).with.offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
    }];
    
    [self.cashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_top).with.offset(50);
        make.left.mas_equalTo(self.view).with.offset(30);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
    }];
    [self.cashField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_top).with.offset(50);
        make.left.mas_equalTo(self.cashLabel.mas_right).with.offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
    NSString *dbPath = [self dataFilePath];
    cashItemdb = [FMDatabase databaseWithPath:dbPath] ;
    if (![cashItemdb open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    NSString *selectSQL = [NSString stringWithFormat: @"select * from cashItem where id = %ld",self.cashId];
    FMResultSet *result=[cashItemdb executeQuery:selectSQL];
    while(result.next){
        self.contentField.text = [result stringForColumn:@"cashString"];
        self.cashField.text = [NSString stringWithFormat:@"%f",[result doubleForColumn:@"cost"]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSString *cashString = self.contentField.text;
    NSString *cost = self.cashField.text;
    
    NSString * updateSQL=[NSString stringWithFormat:@"update 'cashItem' set 'cashString' = '%@', 'cost' = '%@' where id = %ld",cashString,cost,(long)self.cashId];
    
    BOOL res = [cashItemdb executeUpdate:updateSQL];
    if (!res) {
        NSLog(@"error when update db table");
    } else {
        NSLog(@"success to update db table");
    }

    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTableNotification" object:nil];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    _label.frame = CGRectMake(20, 10, self.view.frame.size.width - 40, self.view.frame.size.height - 20);
}

@end
