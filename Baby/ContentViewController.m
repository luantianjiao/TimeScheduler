//
//  ContentViewController.m
//  Baby
//
//  Created by luan on 16/5/24.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "ContentViewController.h"
#import "Masonry.h"
#import <FMDB.h>

@interface ContentViewController ()

@property(strong,nonatomic) UIPickerView *selectPicker;
@property(strong,nonatomic) UITextField *textField;
@property(strong,nonatomic) UITextField *contentField;
@property(strong,nonatomic) UISwitch *switchBar;
@property(strong,nonatomic) UILabel *label;


@property(strong,nonatomic) NSArray *pickerArray;

@end

@implementation ContentViewController
FMDatabase *dataBase123;

-(void)setDetailItem:(NSInteger)newDetailItem{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    return dbPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"content view controller");
    // Do any additional setup after loading the view.
    self.pickerArray = [NSArray arrayWithObjects:@"Running",@"娱乐",@"Sleep",@"iOS", nil];
    
    [self configureView];
    
    NSString *dbPath = [self dataFilePath];
    dataBase123 = [FMDatabase databaseWithPath:dbPath] ;
    if (![dataBase123 open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    NSString * sql=[NSString stringWithFormat:@"select * from hourItem where id = %ld",(long)self.detailItem];
    FMResultSet *result=[dataBase123 executeQuery:sql];
    while(result.next){
        self.navigationItem.title  = [result stringForColumn:@"hour"];
        self.textField.text =[result stringForColumn:@"type"];
        self.contentField.text = [result stringForColumn:@"content"];
        self.switchBar.on = [result boolForColumn:@"isDone"];
    }
}

-(void)configureView{
    
    //top left bottom right
//    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(80);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self.view.frame.size.width - 150.0);
    }];
    
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField).with.offset(80);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self.view.frame.size.width - 150.0);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentField).with.offset(80);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(self.contentField);
        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(self.view.frame.size.width - 300);
    }];
    
    [self.switchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentField).with.offset(85);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(self.label).with.offset(100);
        make.centerY.mas_equalTo(self.label);
        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(self.view.frame.size.width - 150.0);
    }];
}

- (UIPickerView *)selectPicker{
    if (!_selectPicker) {
        _selectPicker = [[UIPickerView alloc]init];
        _selectPicker.delegate = self;
        _selectPicker.dataSource = self;
//        [_selectPicker addTarget:self action:@selector(chooseDate:) forControlEvents: UIControlEventValueChanged];
//        [self.view addSubview:_selectPicker];
        _selectPicker.showsSelectionIndicator = YES;
    }
    return _selectPicker;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"If Done";
        [self.view addSubview:_label];
    }
    return _label;
}

-(UISwitch *)switchBar{
    if (!_switchBar) {
        _switchBar = [[UISwitch alloc]init];
        [self.view addSubview:_switchBar];
    }
    return _switchBar;
}

- (UITextField *)textField {
    if (! _textField) {
        _textField = [[UITextField alloc] init];
        [_textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        _textField.tag = 1001;
        _textField.delegate= self;
//        [_textField removeFromSuperview];
//        _textField.inputView = self.selectPicker;
        [self.view addSubview:_textField];
    }
    return _textField;
}

- (UITextField *)contentField {
    if (! _contentField) {
        _contentField = [[UITextField alloc] init];
        [_contentField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        _contentField.delegate= self;
        [self.view addSubview:_contentField];
    }
    return _contentField;
}

-(void)viewWillDisappear:(BOOL)animated{
    NSString *type = self.textField.text;
    NSString *content = self.contentField.text;
    bool isDone = self.switchBar.on;
    
    NSString * updateSQL=[NSString stringWithFormat:@"update 'hourItem' set 'type' = '%@', 'content' = '%@', 'isDone' = %@ where id = %ld",type,content,@(isDone),(long)self.detailItem];
    
    BOOL res = [dataBase123 executeUpdate:updateSQL];
    if (!res) {
        NSLog(@"error when update db table");
    } else {
        NSLog(@"success to update db table");
    }
}

#pragma mark - UIPickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerArray count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.textField.text = [self.pickerArray objectAtIndex:row];
}

#pragma mark TextField Delegate


-(IBAction)backgroundTap:(id)sender {
    NSInteger row = [self.selectPicker selectedRowInComponent:0];
    self.textField.text = [self.pickerArray objectAtIndex:row];
    
    [self.textField resignFirstResponder];
    [self.contentField resignFirstResponder];
    
    if (self.selectPicker) {
        [self.selectPicker removeFromSuperview];
    }
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    //如果当前要显示的键盘，那么把selectPicker（如果在视图中）隐藏
    if (textField.tag != 1001) {
        if (self.selectPicker.superview) {
            [self.selectPicker removeFromSuperview];
        }
        return YES;
    }
    
    //UIDatePicker以及在当前视图上就不用再显示了
    if (textField.tag == 1001) {
        if (self.selectPicker.superview == nil) {
//            close all keyboard or data picker visible currently
            [self.contentField resignFirstResponder];
            
            //此处将Y坐标设在最底下，为了一会动画的展示
            self.selectPicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216);
            
            [self.view addSubview:self.selectPicker];
            
            [self.selectPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-20);
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.height.mas_equalTo(200);
                make.width.mas_equalTo(self.view.frame.size.width - 20.0);
            }];
            
            NSInteger index = [self.pickerArray indexOfObject:self.textField.text];
            [self.selectPicker selectRow:index inComponent:0 animated:NO];

            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            [UIView commitAnimations];
        }
    }
    
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
