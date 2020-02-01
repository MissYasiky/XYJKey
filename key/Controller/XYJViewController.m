//
//  XYJViewController.m
//  key
//
//  Created by MissYasiky on 2018/11/2.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJViewController.h"
#import "XYJMenuViewController.h"
#import "XYJBankCardDetailViewController.h"
#import "XYJAddBankCardViewController.h"
#import "XYJDetailLabelCell.h"
#import "XYJCacheUtils.h"
#import "XYJBankCardDao.h"

@interface XYJViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XYJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XYJColor(0xf4f4f4);
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    __weak __typeof(self)weakSelf = self;
    [[XYJBankCardDao sharedDao] getDataWithCompletionBlock:^(NSArray<NSDictionary *> *datas) {
        [weakSelf.dataArray addObjectsFromArray:datas];
        [weakSelf.tableView reloadData];
        weakSelf.tableView.dataSource = self;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newBankCardAdded:) name:XYJAddNewBankCardNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bankCardEdited:) name:XYJEditBankCardNotification object:nil];
    
    [self initNavigationBar];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _tableView.delegate = nil;
}

#pragma mark - Initialization

- (void)initNavigationBar {
    UIImage *image = [UIImage imageNamed:@"navigation_btn_menu"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonAction)];
    [leftItem setTintColor:XYJColor(0x4c4c4c)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBankCard)];
    [item setTintColor:XYJColor(0x4c4c4c)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    [backItem setTintColor:XYJColor(0x4c4c4c)];
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XYJScreenWidth(), XYJScreenHeight()) style:UITableViewStylePlain];
        _tableView.backgroundColor = XYJColor(0xf4f4f4);
        _tableView.delegate = self;
        
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
    }
    return _tableView;
}

#pragma mark - Action

- (void)menuButtonAction {
    XYJMenuViewController *vctrl = [[XYJMenuViewController alloc] init];
    [self.navigationController pushViewController:vctrl animated:YES];
}

- (void)addBankCard {
    XYJAddBankCardViewController *vctrl = [[XYJAddBankCardViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vctrl];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

#pragma mark - NSNotification

- (void)newBankCardAdded:(NSNotification *)notif {
    id dict = notif.object;
    [self.dataArray addObject:dict];
}

- (void)bankCardEdited:(NSNotification *)notif {
    id data = notif.object;
    NSString *dataId = data[XYJBankCardID];
    for (int i = 0; i < [self.dataArray count]; i++) {
        NSDictionary *dict = self.dataArray[i];
        if ([dataId isEqualToString:dict[XYJBankCardID]]) {
            [self.dataArray replaceObjectAtIndex:i withObject:data];
        }
    }
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
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator selectionStyle:UITableViewCellSelectionStyleDefault];
    }
    NSDictionary *info = self.dataArray[indexPath.row];
    NSInteger bankIndex = [info[XYJBankName] integerValue];
    NSString *leftContent = [XYJCacheUtils bankNameArray][bankIndex];
    
    NSString *account = info[XYJBankCardID];
    NSString *rightContent = [NSString stringWithFormat:@"尾号%@", account.length >= 4 ? [account substringFromIndex:account.length - 4] : account];
    [cell setLeftLabelText:leftContent rightLabelText:rightContent];
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XYJDetailLabelCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XYJBankCardDetailViewController *vctrl = [[XYJBankCardDetailViewController alloc] initWithData:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:vctrl animated:YES];
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
    __weak __typeof(self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"删除后数据不可恢复" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *info = weakSelf.dataArray[indexPath.row];
        NSString *dataId = info[XYJBankCardID];
        [[XYJBankCardDao sharedDao] deleteDataWithId:dataId
                                     completionBlock:^(BOOL success) {
                                         if (success) {
                                             [self.dataArray removeObjectAtIndex:indexPath.row];
                                             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                         }
                                     }];
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
