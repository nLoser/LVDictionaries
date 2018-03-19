//
//  LookupController.m
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LookupController.h"

@interface LookupController ()
@property (nonatomic, strong) UITextField * lookupField;
@end

@implementation LookupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.lookupField];
}

#pragma mark - Getter

- (UITextField *)lookupField {
    if (!_lookupField) {
        _lookupField = [[UITextField alloc] initWithFrame:CGRectMake(22, 36, [UIScreen mainScreen].bounds.size.width-44, 50)];
        _lookupField.textAlignment = NSTextAlignmentCenter;
        _lookupField.font = [UIFont boldSystemFontOfSize:25];
        _lookupField.textColor = [UIColor colorWithRed:0 green:0.46 blue:0.98 alpha:1];
        _lookupField.layer.cornerRadius = 10;
        _lookupField.backgroundColor = [UIColor grayColor];
        _lookupField.placeholder = @"查询单词";
        
    }
    return _lookupField;
}

@end
