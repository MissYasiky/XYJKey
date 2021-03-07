//
//  XYJAccountListViewController.m
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJAccountListViewController.h"
#import "XYJAccountDetailViewController.h"
#import "XYJHomeListCell.h"

/// 数据
#import "XYJAccount.h"
#import "XYJAccountDataBase.h"

@interface XYJAccountListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <XYJAccount *> *dataArray;

@end

@interface XYJAccountListViewController ()

@end

@implementation XYJAccountListViewController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self getAccountDataFromDataBase];
    }
    return self;
}

- (void)getAccountDataFromDataBase {
    NSArray *dataArray = [[XYJAccountDataBase sharedDataBase] getAllData];
    if (!_dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    if (dataArray) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:dataArray];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardDataChange:) name:XYJAccountDataAddNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardDataChange:) name:XYJAccountDataDeleteNotification object:nil];
}

- (void)viewWillLayoutSubviews {
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)dealloc {
    _tableView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - Notification

- (void)cardDataChange:(NSNotification *)notif {
    [self getAccountDataFromDataBase];
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.dataArray count]) {
        return [UITableViewCell new];
    }
    static NSString *cellIdentifier = @"cellIdentifier";
    XYJHomeListCell *cell = (XYJHomeListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[XYJHomeListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
        [cell setCellStyleForAccount:YES];
    }
    XYJAccount *account = [self.dataArray objectAtIndex:indexPath.row];
    NSString *detailString = @"";
    if (account.externDict && [account.externDict count] > 0) {
        NSString *keyString = [account.externDict allKeys][0];
        detailString = [NSString stringWithFormat:@"%@: %@", keyString, account.externDict[keyString]];
    }
    [cell setTextForLineOne:account.accountName lineTwo:nil lineThree:detailString];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XYJAccount *account = [self.dataArray objectAtIndex:indexPath.row];
    XYJAccountDetailViewController *vctrl = [[XYJAccountDetailViewController alloc] initWithAccount:account];
    [self.navigationController pushViewController:vctrl animated:YES];
}

@end
