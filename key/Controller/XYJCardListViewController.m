//
//  XYJCardListViewController.m
//  key
//
//  Created by MissYasiky on 2020/2/1.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCardListViewController.h"
#import "XYJCardDetailViewController.h"
#import "XYJHomeListCell.h"

#import "XYJCard.h"
#import "XYJCardDataBase.h"

@interface XYJCardListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <XYJCard *> *dataArray;

@end

@implementation XYJCardListViewController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] initWithArray:[[XYJCardDataBase sharedDataBase] getAllData]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    if (indexPath.row >= [self.dataArray count]) {
        return [UITableViewCell new];
    }
    static NSString *cellIdentifier = @"cellIdentifier";
    XYJHomeListCell *cell = (XYJHomeListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[XYJHomeListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
    }
    XYJCard *card = [self.dataArray objectAtIndex:indexPath.row];
    NSString *creditCardString = card.isCreditCard == 1 ? @"信用卡" : @"借记卡";
    [cell setTextForLineOne:card.bankName lineTwo:creditCardString lineThree:card.accountNum other:card.isOwn == 0];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XYJCard *card = [self.dataArray objectAtIndex:indexPath.row];
    XYJCardDetailViewController *vctrl = [[XYJCardDetailViewController alloc] initWithCard:card];
    [self.navigationController pushViewController:vctrl animated:YES];
}

@end
