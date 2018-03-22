//
//  HistoryController.m
//  LVDictionaries
//
//  Created by LV on 2018/3/22.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "HistoryController.h"
#import "Global.h"
#import "LVFileManager.h"

@interface HistoryController () {
    NSMutableArray * _dataSource;
}
@end

@implementation HistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    
    self.view.backgroundColor = Color1;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
