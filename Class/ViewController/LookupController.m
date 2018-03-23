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
#import "UIView+GetRect.h"
#import "LVViewControllerAnimationTransition.h"

#import "Global.h"
#import "LVView.h"

@interface LookupController ()<UITextFieldDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) LVViewControllerAnimationTransition * vcTransition;
@property (nonatomic, strong) UITextField * lookupField;
@property (nonatomic, strong) LVWordDetailView * wordDetailView;
@property (nonatomic, strong) UIButton * button;
@end

@implementation LookupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColor;
    
    [self setupUI];
    
    _vcTransition = [[LVViewControllerAnimationTransition alloc] init];
    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[LVFileManager shareDefault] checkLocalDatabase]) {
        [self.lookupField becomeFirstResponder];
    }
}

- (void)setupUI {
    [self.view addSubview:self.lookupField];
    [self.view addSubview:self.wordDetailView];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = self.lookupField.frame;
    self.button.lvBottom = 400;
    [self.button addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    self.button.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downKeyborad)]];
}

- (void)tap {
    [self.navigationController pushViewController:[LVVCControl HistoryController] animated:YES];
}

#pragma mark - Target Action

- (void)downKeyborad {
    [self.lookupField resignFirstResponder];
}

#pragma mark - <UINavigationControllerDelegate>

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        _vcTransition.isPush = YES;
        return _vcTransition;
    }else if (operation == UINavigationControllerOperationPop) {
        _vcTransition.isPush = NO;
        return _vcTransition;
    }else {
        return nil;
    }
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
        _lookupField.clearButtonMode = UITextFieldViewModeAlways;
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
