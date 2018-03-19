//
//  LookupController.m
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LookupController.h"
#import "LVVCControl.h"
#import "LVFileManager.h"

@interface LookupController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * lookupField;
@property (nonatomic, strong) UILabel * lable;
@end

@implementation LookupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColor;
    
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[LVFileManager shareDefault] checkLocalDatabase];
}

- (void)setupUI {
    [self.view addSubview:self.lookupField];
    [self.view addSubview:self.lable];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downKeyborad)]];
}

#pragma mark - Target Action

- (void)downKeyborad {
    [self.lookupField resignFirstResponder];
}

#pragma mark - Getter

- (UITextField *)lookupField {
    if (!_lookupField) {
        _lookupField = [[UITextField alloc] initWithFrame:CGRectMake(22, 44, [UIScreen mainScreen].bounds.size.width-44, 45)];
        _lookupField.textAlignment = NSTextAlignmentCenter;
        _lookupField.font = [UIFont boldSystemFontOfSize:20];
        _lookupField.textColor = Color2;
        _lookupField.backgroundColor = BgColor;
        _lookupField.layer.borderColor = Color1.CGColor;
        _lookupField.layer.borderWidth = 2;
        _lookupField.returnKeyType = UIReturnKeySearch;
        _lookupField.placeholder = @"look up";
        _lookupField.delegate = self;
    }
    return _lookupField;
}

- (UILabel *)lable {
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(22, 110, [UIScreen mainScreen].bounds.size.width-44, 50)];
        _lable.font = [UIFont systemFontOfSize:12];
    }
    return _lable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    __weak typeof(self) weakSelf = self;
    [[LVFileManager shareDefault] searchWord:textField.text result:^(LVWordDetail * rt) {
        weakSelf.lable.text = [NSString stringWithFormat:@"%@-%@-%@-%d",rt.word,rt.symbol,rt.explian,rt.lookupNum];
    }];
    
    return YES;
}

@end
