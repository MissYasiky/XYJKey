//
//  XYJViewController.m
//  key
//
//  Created by MissYasiky on 2018/11/2.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJViewController.h"
#import "XYJAddBankCardViewController.h"
#import "XYJCacheUtils.h"

@interface XYJViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XYJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XYJColor(0xf4f4f4, 1.0);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBankCard)];
    [item setTintColor:XYJColor(0x4c4c4c, 1.0)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XYJScreenWidth(), XYJScreenHeight()) style:UITableViewStylePlain];
        _tableView.backgroundColor = XYJColor(0xf4f4f4, 1.0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
    }
    return _tableView;
}

#pragma mark - Action

- (void)addBankCard {
    XYJAddBankCardViewController *vctrl = [[XYJAddBankCardViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vctrl];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[XYJCacheUtils bankCardFromCache] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = XYJColor(0x696969, 1.0);
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = XYJColor(0xa4a4a4, 1.0);
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *dataArray = [XYJCacheUtils bankCardFromCache];
    NSDictionary *info = dataArray[indexPath.row];
    NSInteger bankIndex = [info[XYJBankNameKey] integerValue];
    cell.textLabel.text = [XYJCacheUtils bankNameArray][bankIndex];
    
    NSString *account = info[XYJBankAccountKey];
    NSString *detailText = [NSString stringWithFormat:@"尾号%@", account.length >= 4 ? [account substringFromIndex:account.length - 4] : account];
    cell.detailTextLabel.text = detailText;
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"删除后数据不可恢复" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        BOOL success = [XYJCacheUtils deleteBankCardAtIndex:indexPath.row];
        if (success) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:deleteAction];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
