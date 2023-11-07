//
//  XYJAccountDetailViewController.m
//  key
//
//  Created by MissYasiky on 2021/3/5.
//  Copyright © 2021 netease. All rights reserved.
//

#import "XYJAccountDetailViewController.h"
#import "XYJAccountEditViewController.h"
#import "XYJDetailLabelCell.h"

@interface XYJAccountDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
XYJDetailLabelCellProtocol
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Account *account;

@end

@implementation XYJAccountDetailViewController

#pragma mark - Life Cycle

- (instancetype)initWithAccount:(Account *)account {
    self = [super init];
    if (self) {
        _account = account;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.account.accountName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];

    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountDataAdd:) name:XYJAccountDataAddNotification object:nil];
}

- (void)dealloc {
    _tableView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - Notification

- (void)accountDataAdd:(NSNotification *)notif {
    Account *account = (Account *)notif.object;
    self.account = account;
    
    self.title = self.account.accountName;
    [self.tableView reloadData];
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = [XYJDetailLabelCell height];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - Action

- (void)menuButtonAction {
    __weak __typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf editAccountAction];
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

- (void)editAccountAction {
    XYJAccountEditViewController *vctrl = [[XYJAccountEditViewController alloc] initWithAccount:self.account];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vctrl];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)deleteAccountAction {
    BOOL success = [[AccountDataBase shared] deleteDataWithCreateTime:self.account.createTime];
    if (success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XYJAccountDataDeleteNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [XYJToast showToastWithMessage:@"删除失败" inView:self.view];
    }
}

- (void)showDeleteAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除该账户信息？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteAccountAction];
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
    return [self.account.externDict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.account.externDict count]) {
        return [UITableViewCell new];
    }
    
    static NSString *cellIdentifier = @"cellIdentifier";
    XYJDetailLabelCell *cell = (XYJDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[XYJDetailLabelCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    NSString *title = [self.account.externDict allKeys][indexPath.row];
    NSString *content = [self.account.externDict allValues][indexPath.row];
    [cell setTextForLineOne:title lineTwo:content];
    return cell;
}

#pragma mark - XYJDetailLabelCell Protocol

- (void)detailLabelCell_showToast:(NSString *)message {
    [XYJToast showToastWithMessage:message inView:self.view];
}

@end
