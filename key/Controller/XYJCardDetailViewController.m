//
//  XYJCardDetailViewController.m
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCardDetailViewController.h"
#import "XYJCardEditViewController.h"
#import "XYJDetailLabelCell.h"
#import "XYJCardView.h"
#import "XYJCard.h"
#import "XYJCardDataBase.h"

@interface XYJCardDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) XYJCardView *cardView;
@property (nonatomic, strong) XYJCard *card;

@end

@implementation XYJCardDetailViewController

#pragma mark - Life Cycle

- (instancetype)initWithCard:(XYJCard *)card {
    self = [super init];
    if (self) {
        _card = card;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.card.bankName;
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
    [rightButton setImage:[UIImage imageNamed:@"nav_btn_menu"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"nav_btn_menu_highlight"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = menuItem;
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
        _cardView = [[XYJCardView alloc] initWithCard:self.card];
        CGFloat padding = 25;
        CGFloat cardBgHeight = (XYJ_ScreenWidth - padding * 2) * 210 / 325;
        CGFloat height = cardBgHeight + padding * 2;
        _cardView.frame = CGRectMake(0, 0, XYJ_ScreenWidth, height);
    }
    return _cardView;
}

#pragma mark - Action

- (void)menuButtonAction {
    __weak __typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf editCardAction];
    }];
    [editAction setValue:[XYJColorUtils colorWithHexString:XYJ_Theme_Blue_Color] forKey:@"titleTextColor"];

    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showDeleteAlert];
    }];
    [deleteAction setValue:[XYJColorUtils colorWithHexString:XYJ_Theme_Red_Color] forKey:@"titleTextColor"];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancleAction setValue:[XYJColorUtils colorWithHexString:XYJ_Theme_Blue_Color] forKey:@"titleTextColor"];
    
    [alert addAction:editAction];
    [alert addAction:deleteAction];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Private

- (void)editCardAction {
    XYJCardEditViewController *vctrl = [[XYJCardEditViewController alloc] initWithCard:self.card];
    vctrl.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:vctrl animated:YES completion:nil];
}

- (void)showDeleteAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除该银行卡信息？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[XYJCardDataBase sharedDataBase] deleteDataWithCreateTime:self.card.createTime];
    }];
    [deleteAction setValue:[XYJColorUtils colorWithHexString:XYJ_Theme_Red_Color] forKey:@"titleTextColor"];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancleAction setValue:[XYJColorUtils colorWithHexString:XYJ_Theme_Blue_Color] forKey:@"titleTextColor"];
    
    [alert addAction:deleteAction];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.card.externDict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.card.externDict count]) {
        return [UITableViewCell new];
    }
    
    static NSString *cellIdentifier = @"cellIdentifier";
    XYJDetailLabelCell *cell = (XYJDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[XYJDetailLabelCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
    }
    NSString *title = [self.card.externDict allKeys][indexPath.row];
    NSString *content = [self.card.externDict allValues][indexPath.row];
    [cell setTextForLineOne:title lineTwo:content];
    return cell;
}

@end
