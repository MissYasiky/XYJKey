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

@interface XYJCardListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <Card *> *dataArray;

@end

@implementation XYJCardListViewController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self getCardDataFromDataBase];
    }
    return self;
}

- (void)getCardDataFromDataBase {
    NSArray *dataArray = [[CardDataBase shared] getAllData];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardDataChange:) name:XYJCardDataAddNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardDataChange:) name:XYJCardDataDeleteNotification object:nil];
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
    [self getCardDataFromDataBase];
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
    }
    Card *card = [self.dataArray objectAtIndex:indexPath.row];
    [cell setTextForLineOne:card.bankName lineTwo:card.cardType lineThree:card.accountNum other:!card.isOwn];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Card *card = [self.dataArray objectAtIndex:indexPath.row];
    XYJCardDetailViewController *vctrl = [[XYJCardDetailViewController alloc] initWithCard:card];
    [self.navigationController pushViewController:vctrl animated:YES];
}

@end
