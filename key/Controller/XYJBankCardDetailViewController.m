//
//  XYJBankCardDetailViewController.m
//  key
//
//  Created by MissYasiky on 2018/12/1.
//  Copyright © 2018 netease. All rights reserved.
//

#import "XYJBankCardDetailViewController.h"
#import "XYJAddBankCardViewController.h"
#import "XYJDetailLabelCell.h"
#import "XYJSwitchCell.h"
#import "XYJTextViewCell.h"
#import "XYJCacheUtils.h"

@interface XYJBankCardDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

/*
 * 列表相关属性
 */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, assign) NSInteger dataIndex;

@end

@implementation XYJBankCardDetailViewController

- (instancetype)initWithData:(NSDictionary *)dict index:(NSInteger)index {
    self = [super init];
    if (self) {
        self.dataDict = dict;
        self.dataIndex = index;
        self.titleArray = @[XYJBankNameKey, XYJBankAccountKey, XYJBankCreditCardKey, XYJEBankPasswordKey, XYJBankQueryPasswordKey, XYJBankWithdrawalPasswordKey];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XYJColor(0xf4f4f4, 1.0);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    [backItem setTintColor:XYJColor(0x4c4c4c, 1.0)];
    [editItem setTintColor:XYJColor(0x4c4c4c, 1.0)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.rightBarButtonItem = editItem;
    
    [self.view addSubview:self.tableView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _tableView.delegate = nil;
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XYJScreenWidth(), XYJScreenHeight()) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = XYJColor(0xf4f4f4, 1.0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - Action

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)edit {
    XYJAddBankCardViewController *vctrl = [[XYJAddBankCardViewController alloc] initWithData:self.dataDict index:self.dataIndex];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vctrl];
    [self.navigationController presentViewController:navi animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bankCardEdited:) name:XYJEditBankCardNotification object:nil];
    }];
}

#pragma mark - NSNotification

- (void)bankCardEdited:(NSNotification *)notif {
    id object = notif.object;
    NSNumber *indexNumber = (NSNumber *)object;
    NSInteger index = [indexNumber integerValue];
    self.dataDict = [XYJCacheUtils bankCardAtIndex:index];
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            static NSString *cellRow2Identifier = @"cellRow2Identifier";
            XYJSwitchCell *cell = (XYJSwitchCell *)[tableView dequeueReusableCellWithIdentifier:cellRow2Identifier];
            if (cell == nil) {
                cell = [[XYJSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cellRow2Identifier];
            }
            NSString *key = self.titleArray[indexPath.row];
            BOOL on = [self.dataDict[key] boolValue];
            [cell setLeftLabelText:key switchOn:on];
            cell.aSwitch.enabled = NO;
            return cell;
        } else {
            static NSString *cellRow0Identifier = @"cellRow0Identifier";
            XYJDetailLabelCell *cell = (XYJDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellRow0Identifier];
            if (cell == nil) {
                cell = [[XYJDetailLabelCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:cellRow0Identifier];
            }
            NSString *key = self.titleArray[indexPath.row];
            if (indexPath.row == 0) {
                NSInteger index = [self.dataDict[key] integerValue];
                [cell setLeftLabelText:key rightLabelText:[XYJCacheUtils bankNameArray][index]];
            } else {
                [cell setLeftLabelText:key rightLabelText:self.dataDict[key]];
            }
            return cell;
            
        }
    } else {
        static NSString *cellIdentifier2 = @"cellIdentifier2";
        XYJTextViewCell *cell = (XYJTextViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell == nil) {
            cell = [[XYJTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier2];
        }
        [cell setTextViewContent:self.dataDict[XYJBankRemarkKey]];
        cell.textView.editable = NO;
        return cell;
    }
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [XYJDetailLabelCell height];
    } else {
        return [XYJTextViewCell height];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYJScreenWidth(), 10)];
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYJScreenWidth(), 22)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 22)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = XYJColor(0x696969, 1.0);
        label.text = XYJBankRemarkKey;
        [view addSubview:label];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0;
    } else {
        return 22.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
