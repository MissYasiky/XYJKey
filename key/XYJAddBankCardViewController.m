//
//  XYJAddBankCardViewController.m
//  key
//
//  Created by MissYasiky on 2018/11/14.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJAddBankCardViewController.h"

@interface XYJAddBankCardViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation XYJAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XYJColor(0xf4f4f4, 1.0);
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [cancelItem setTintColor:XYJColor(0x4c4c4c, 1.0)];
    [saveItem setTintColor:XYJColor(0x4c4c4c, 1.0)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.rightBarButtonItem = saveItem;
    
    [self.view addSubview:self.tableView];
    [self.view addGestureRecognizer:self.tap];
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

- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = @[@"银行",@"账号",@"信用卡",@"网银密码",@"查询密码",@"取款密码"];
    }
    return _titleArray;
}

- (UITapGestureRecognizer *)tap {
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    }
    return _tap;
}
#pragma mark - Action

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)save {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hiddenKeyboard {
    [self.view endEditing:YES];
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
        if (indexPath.row == 0) {
            static NSString *cellRow0Identifier = @"cellRow0Identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRow0Identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellRow0Identifier];
                cell.textLabel.font = [UIFont systemFontOfSize:18];
                cell.textLabel.textColor = XYJColor(0x696969, 1.0);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                UILabel *label = [[UILabel alloc] init];
                label.text = @"招商银行";
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = XYJColor(0xa4a4a4, 1.0);
                label.textAlignment = NSTextAlignmentRight;
                label.frame = CGRectMake(120, 11, XYJScreenWidth() - 120 - 30, 20);
                [cell.contentView addSubview:label];
            }
            cell.textLabel.text = self.titleArray[indexPath.row];
            return cell;
        } else if (indexPath.row == 2) {
            static NSString *cellRow2Identifier = @"cellRow2Identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRow2Identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellRow2Identifier];
                cell.textLabel.font = [UIFont systemFontOfSize:18];
                cell.textLabel.textColor = XYJColor(0x696969, 1.0);
                
                UISwitch *onoff = [[UISwitch alloc] init];
                onoff.on = YES;
                CGPoint point = CGPointZero;
                point.x = XYJScreenWidth() - onoff.frame.size.width - 15;
                point.y = (42 - onoff.frame.size.height) / 2.;
                onoff.frame = CGRectMake(point.x, point.y, 0, 0);
                [cell.contentView addSubview:onoff];
            }
            cell.textLabel.text = self.titleArray[indexPath.row];
            return cell;
        } else {
            static NSString *cellIdentifier = @"cellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellIdentifier];
                cell.textLabel.font = [UIFont systemFontOfSize:18];
                cell.textLabel.textColor = XYJColor(0x696969, 1.0);
                
                UITextField *textField = [[UITextField alloc] init];
                textField.font = [UIFont systemFontOfSize:16];
                textField.textColor = XYJColor(0xa4a4a4, 1.0);
                textField.textAlignment = NSTextAlignmentRight;
                textField.frame = CGRectMake(120, 11, XYJScreenWidth() - 120 - 15, 20);
                [cell.contentView addSubview:textField];
            }
            cell.textLabel.text = self.titleArray[indexPath.row];
            return cell;
        }
        
    } else {
        static NSString *cellIdentifier2 = @"cellIdentifier2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier2];
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, XYJScreenWidth() - 30, 100 - 30)];
            textView.font = [UIFont systemFontOfSize:16];
            textView.textColor = XYJColor(0xa4a4a4, 1.0);
            [cell.contentView addSubview:textView];
        }
        return cell;
    }
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 42.0;
    } else {
        return 100.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYJScreenWidth(), 10)];        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYJScreenWidth(), 22)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 22)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = XYJColor(0x696969, 1.0);
        label.text = @"备注";
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

@end
