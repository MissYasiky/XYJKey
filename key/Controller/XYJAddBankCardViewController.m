//
//  XYJAddBankCardViewController.m
//  key
//
//  Created by MissYasiky on 2018/11/14.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJAddBankCardViewController.h"
#import "XYJPickerCell.h"
#import "XYJSwitchCell.h"
#import "XYJTextFieldCell.h"
#import "XYJTextViewCell.h"
#import "XYJCacheUtils.h"

static CGFloat pickerHeight = 200.0;
static CGFloat pickerToolbarHeight = 34.0;
static CGFloat pickerRowHeight = 34.0;

static NSInteger kTextFieldTagPlus = 100;

@interface XYJAddBankCardViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource,
UITextFieldDelegate,
UITextViewDelegate
>

/*
 * 列表相关属性
 */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSDictionary *placeholderDict;
@property (nonatomic, strong) NSDictionary *keyboardTypeDict;
@property (nonatomic, strong) NSMutableDictionary *inputDataDict;

/*
 * 选择器相关属性
 */
@property (nonatomic, strong) UIView *pickerBackgroundView;
@property (nonatomic, strong) UITapGestureRecognizer *pickerViewTap;
@property (nonatomic, strong) UIToolbar *pickerToolBar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger pickerSelectedIndex;
@property (nonatomic, strong) NSArray *pickerDataArray;

@property (nonatomic, strong) UITapGestureRecognizer *hiddenKeyboardTap;

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
    
    [self initData];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.pickerBackgroundView];
    [self.pickerBackgroundView addGestureRecognizer:self.pickerViewTap];
    [self.pickerBackgroundView addSubview:self.pickerToolBar];
    [self.pickerBackgroundView addSubview:self.pickerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _tableView.delegate = nil;
    _pickerView.delegate = nil;
}

#pragma mark initialize

- (void)initData {
    self.pickerSelectedIndex = 0;
    self.pickerDataArray = [XYJCacheUtils bankNameArray];
    
    self.titleArray = @[XYJBankNameKey, XYJBankAccountKey, XYJBankCreditCardKey, XYJEBankPasswordKey, XYJBankQueryPasswordKey, XYJBankWithdrawalPasswordKey];
    
    self.placeholderDict = @{self.titleArray[1]:@"请输入银行账号", self.titleArray[3]:@"请输入网银密码",  self.titleArray[4]:@"请输入查询密码",  self.titleArray[5]:@"请输入取款密码"};
    
    self.keyboardTypeDict = @{self.titleArray[1]:@(UIKeyboardTypeNumberPad), self.titleArray[3]:@(UIKeyboardTypeDefault),  self.titleArray[4]:@(UIKeyboardTypeNumberPad),  self.titleArray[5]:@(UIKeyboardTypeNumberPad)};
    
    self.inputDataDict = [NSMutableDictionary new];
    NSDictionary *dict = @{self.titleArray[0]:@(self.pickerSelectedIndex), self.titleArray[1]:@"",  self.titleArray[2]:@(0),  self.titleArray[3]:@"",  self.titleArray[4]:@"",  self.titleArray[5]:@"",  XYJBankRemarkKey:@""};
    self.inputDataDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
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

- (UIView *)pickerBackgroundView {
    if (_pickerBackgroundView == nil) {
        _pickerBackgroundView = [[UIView alloc] init];
        _pickerBackgroundView.backgroundColor = [UIColor clearColor];
        _pickerBackgroundView.hidden = YES;
        _pickerBackgroundView.frame = self.view.bounds;
    }
    return _pickerBackgroundView;
}

- (UIToolbar *)pickerToolBar {
    if (_pickerToolBar == nil) {
        _pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, XYJScreenHeight(), XYJScreenWidth(), pickerToolbarHeight)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                 style:UIBarButtonItemStylePlain target:self action:@selector(hiddenPicker:)];
        _pickerToolBar.items = @[space, item];
    }
    return _pickerToolBar;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.frame = CGRectMake(0, XYJScreenHeight(), XYJScreenWidth(), pickerHeight);
    }
    return _pickerView;
}

- (UITapGestureRecognizer *)pickerViewTap {
    if (_pickerViewTap == nil) {
        _pickerViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPicker:)];
    }
    return _pickerViewTap;
}

- (UITapGestureRecognizer *)hiddenKeyboardTap {
    if (_hiddenKeyboardTap == nil) {
        _hiddenKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    }
    return _hiddenKeyboardTap;
}

#pragma mark - Action

- (void)dismiss {
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)save {
    [self.view endEditing:YES];
    [XYJCacheUtils writeBankCardToCache:self.inputDataDict];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hiddenKeyboard {
    [self.view endEditing:YES];
}

- (void)showPicker {
    self.pickerBackgroundView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerToolBar.frame = CGRectMake(0, XYJScreenHeight() - pickerHeight - pickerToolbarHeight, XYJScreenWidth(), pickerToolbarHeight);
        self.pickerView.frame = CGRectMake(0, XYJScreenHeight() - pickerHeight, XYJScreenWidth(), pickerHeight);
    } completion:nil];
}

- (void)hiddenPicker:(id)sender {
    if (sender != self.pickerViewTap) {
        if (self.pickerSelectedIndex >= 0 && self.pickerSelectedIndex < self.pickerDataArray.count) {
            NSLog(@"%@", self.pickerDataArray[self.pickerSelectedIndex]);
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerToolBar.frame = CGRectMake(0, XYJScreenHeight(), XYJScreenWidth(), pickerToolbarHeight);
        self.pickerView.frame = CGRectMake(0, XYJScreenHeight(), XYJScreenWidth(), pickerHeight);
    } completion:^(BOOL finished) {
        self.pickerBackgroundView.hidden = YES;
    }];
}

- (void)creditCardSwitch:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    NSString *key = self.titleArray[2];
    [self.inputDataDict setObject:@(aSwitch.on) forKey:key];
}

#pragma mark - NSNotification

- (void)keyboardWillShow:(NSNotification *)notification {
    [self.view addGestureRecognizer:self.hiddenKeyboardTap];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.view removeGestureRecognizer:self.hiddenKeyboardTap];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger row = textField.tag - kTextFieldTagPlus;
    NSString *key = self.titleArray[row];
    [self.inputDataDict setObject:textField.text forKey:key];
    NSLog(@"%@", self.inputDataDict);
}

#pragma mark - UITextView Delegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.inputDataDict setObject:textView.text forKey:XYJBankRemarkKey];
    NSLog(@"%@", self.inputDataDict);
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
            XYJPickerCell *cell = (XYJPickerCell *)[tableView dequeueReusableCellWithIdentifier:cellRow0Identifier];
            if (cell == nil) {
                cell = [[XYJPickerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cellRow0Identifier];
            }
            [cell setLeftLabelText:self.titleArray[indexPath.row]
                    rightLabelText:self.pickerDataArray[self.pickerSelectedIndex]];
            return cell;
        } else if (indexPath.row == 2) {
            static NSString *cellRow2Identifier = @"cellRow2Identifier";
            XYJSwitchCell *cell = (XYJSwitchCell *)[tableView dequeueReusableCellWithIdentifier:cellRow2Identifier];
            if (cell == nil) {
                cell = [[XYJSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellRow2Identifier];
            }
            NSString *key = self.titleArray[indexPath.row];
            BOOL on = [self.inputDataDict[key] boolValue];
            [cell setLeftLabelText:key switchOn:on];
            [cell.aSwitch addTarget:self action:@selector(creditCardSwitch:) forControlEvents:UIControlEventValueChanged];
            return cell;
        } else {
            static NSString *cellIdentifier = @"cellIdentifier";
            XYJTextFieldCell *cell = (XYJTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[XYJTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellIdentifier];
            }
            NSString *key = self.titleArray[indexPath.row];
            UIKeyboardType type = [self.keyboardTypeDict[key] integerValue];
            [cell setTextFieldTag:(indexPath.row + kTextFieldTagPlus)
                      placeholder:self.placeholderDict[key]
                         delegate:self
                     keyboardTyep:type];
            [cell setLeftLabelText:key textFieldContent:self.inputDataDict[key]];
            return cell;
        }
        
    } else {
        static NSString *cellIdentifier2 = @"cellIdentifier2";
        XYJTextViewCell *cell = (XYJTextViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell == nil) {
            cell = [[XYJTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier2];
        }
        [cell setTextViewContent:self.inputDataDict[XYJBankRemarkKey] delegate:self];
        return cell;
    }
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [XYJTextFieldCell height];
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self showPicker];
    }
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerDataArray.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerDataArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return pickerRowHeight;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.pickerSelectedIndex = row;
    NSString *key = self.titleArray[0];
    [self.inputDataDict setObject:@(self.pickerSelectedIndex) forKey:key];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

@end
