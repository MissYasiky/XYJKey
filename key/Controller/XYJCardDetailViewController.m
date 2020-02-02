//
//  XYJCardDetailViewController.m
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCardDetailViewController.h"
#import "XYJDetailLabelCell.h"
#import "XYJCardView.h"

@interface XYJCardDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) XYJCardView *cardView;

@end

@implementation XYJCardDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"招商银行";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
    
    self.dataArray = [[NSMutableArray alloc] initWithArray:@[@"aaa", @"bbb"]];
    [self.view addSubview:self.tableView];
}

- (void)dealloc {
    _tableView.delegate = nil;
}

#pragma mark - Initialization

- (void)initNavigationBar {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"nav_btn_edit"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"nav_btn_edit_highlight"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editItem =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = editItem;
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = [XYJDetailLabelCell height];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.cardView;
    }
    return _tableView;
}

- (XYJCardView *)cardView {
    if (_cardView == nil) {
        _cardView = [[XYJCardView alloc] init];
        
        CGFloat padding = 25;
        CGFloat cardBgHeight = (XYJScreenWidth() - padding * 2) * 210 / 325;
        CGFloat height = cardBgHeight + padding * 2;
        _cardView.frame = CGRectMake(0, 0, XYJScreenWidth(), height);
    }
    return _cardView;
}

#pragma mark - Action

- (void)editButtonAction {
//    XYJSettingViewController *vctrl = [[XYJSettingViewController alloc] init];
//    [self.navigationController pushViewController:vctrl animated:YES];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    XYJDetailLabelCell *cell = (XYJDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[XYJDetailLabelCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
    }
    [cell setTextForLineOne:@"查询密码" lineTwo:@"333333"];
    return cell;
}

@end
