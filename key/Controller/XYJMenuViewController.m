//
//  XYJMenuViewController.m
//  key
//
//  Created by MissYasiky on 2019/3/16.
//  Copyright © 2019 netease. All rights reserved.
//

#import "XYJMenuViewController.h"
#import "XYJDetailLabelCell.h"
#import "XYJBankCardDao.h"

@interface XYJMenuViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation XYJMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XYJColor(0xFFFFFF);
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XYJ_ScreenWidth, XYJ_ScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = XYJColor(0xf4f4f4);
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UILongPressGestureRecognizer *)longPress {
    if (_longPress == nil) {
        _longPress = [[UILongPressGestureRecognizer alloc] init];
        _longPress.minimumPressDuration = 6;
        [_longPress addTarget:self action:@selector(longPressAction)];
    }
    return _longPress;
}

#pragma mark - Action

- (void)longPressAction {
    NSData *data = [[XYJBankCardDao sharedDao] dataFromSqlite];
    UIActivityViewController *vctrl = [[UIActivityViewController alloc] initWithActivityItems:@[data] applicationActivities:nil];
    [self presentViewController:vctrl animated:YES completion:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    XYJDetailLabelCell *cell = (XYJDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[XYJDetailLabelCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
        [cell addGestureRecognizer:self.longPress];
    }
    [cell setLeftLabelText:@"版本号"
            rightLabelText:@"version 1.2 build 6"];
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYJ_ScreenWidth, 10)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
