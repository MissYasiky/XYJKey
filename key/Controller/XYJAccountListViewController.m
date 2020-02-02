//
//  XYJAccountListViewController.m
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJAccountListViewController.h"
#import "XYJHomeListCell.h"

@interface XYJAccountListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@interface XYJAccountListViewController ()

@end

@implementation XYJAccountListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = [[NSMutableArray alloc] initWithArray:@[@"aaa", @"bbb", @"ccc"]];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)dealloc {
    _tableView.delegate = nil;
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = [XYJHomeListCell height];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
    }
    return _tableView;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    XYJHomeListCell *cell = (XYJHomeListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[XYJHomeListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
        [cell setCellStyleForAccount:YES];
    }
    [cell setTextForLineOne:@"云闪付" lineTwo:nil lineThree:@"手机号：13316191900"];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    XYJBankCardDetailViewController *vctrl = [[XYJBankCardDetailViewController alloc] initWithData:self.dataArray[indexPath.row]];
//    [self.navigationController pushViewController:vctrl animated:YES];
}

@end