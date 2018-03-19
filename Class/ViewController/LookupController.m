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
#import "Global.h"
#import "LVView.h"
#import "UIView+GetRect.h"

@interface LookupController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * lookupField;
@property (nonatomic, strong) LVWordDetailView * wordDetailView;
@end

@implementation LookupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColor;
    
    [self setupUI];
    
    if ([[LVFileManager shareDefault] checkLocalDatabase]) {
        [self.lookupField becomeFirstResponder];
    }
}

- (void)setupUI {
    [self.view addSubview:self.lookupField];
    [self.view addSubview:self.wordDetailView];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downKeyborad)]];
}

#pragma mark - Target Action

- (void)downKeyborad {
    [self.lookupField resignFirstResponder];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString * searchString = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    textField.text = searchString;
    __weak typeof(self) weakSelf = self;
    [[LVFileManager shareDefault] searchWord:searchString result:^(LVWordDetail * rt) {
        weakSelf.wordDetailView.wordDetail = rt;
    }];
    return YES;
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

- (LVWordDetailView *)wordDetailView{
    if (!_wordDetailView) {
        _wordDetailView = [[LVWordDetailView alloc] initWithFrame:CGRectMake(22, _lookupField.lvBottom + 10, _lookupField.lvWidth, [UIScreen mainScreen].bounds.size.height - 40 - _lookupField.lvBottom)];
    }
    return _wordDetailView;
}

@end
