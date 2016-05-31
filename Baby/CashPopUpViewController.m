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


@interface CashPopUpViewController ()

@property(strong,nonatomic) UILabel *contentLabel;
@property(strong,nonatomic) UITextField *contentField;

@property(strong,nonatomic) UILabel *cashLabel;
@property(strong,nonatomic) UITextField *cashField;

@end

@implementation CashPopUpViewController


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
        [self.view addSubview:_contentField];
    }
    return _contentField;
}

-(UITextField *)cashField{
    if (!_cashField) {
        _cashField = [[UITextField alloc]init];
        _cashField.keyboardType = UIKeyboardTypeNumberPad;
        _cashField.placeholder = @"3.2";
        [self.view addSubview:_cashField];
    }
    return _cashField;
}

-(void)configureView{
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:nil];
    
//    NSLog(@"%@",_detailItem.day);
    
//    _label = [UILabel new];
//    _label.numberOfLines = 0;
//    _label.text = @"Apple Inc. (commonly known as Apple) is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, and online services. Its best-known hardware products are the Mac personal computers, the iPod portable media player, the iPhone smartphone, the iPad tablet computer, and the Apple Watch smartwatch. Apple's consumer software includes the OS X and iOS operating systems, the iTunes media player, the Safari web browser, and the iLife and iWork creativity and productivity suites. Its online services include the iTunes Store, the iOS App Store and Mac App Store, and iCloud.";
//    [self.view addSubview:_label];
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    _label.frame = CGRectMake(20, 10, self.view.frame.size.width - 40, self.view.frame.size.height - 20);
}

@end
