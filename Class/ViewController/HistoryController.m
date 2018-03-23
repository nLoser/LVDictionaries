//
//  HistoryController.m
//  LVDictionaries
//
//  Created by LV on 2018/3/22.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "HistoryController.h"
#import "Global.h"
#import "LVView.h"
#import "LVFileManager.h"

@interface HistoryController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray * _dataSource;
}
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation HistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    
    self.view.backgroundColor = Color1;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_dataSource addObjectsFromArray:[[LVFileManager shareDefault] histroyRecord]];
    [self.tableView reloadData];
}

#pragma mark - <TableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LVHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.wordDetail = _dataSource[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20) style:UITableViewStylePlain];
        _tableView.backgroundColor = BgColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LVHistoryCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (void)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
