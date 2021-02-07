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
#import "XYJBankCardViewModel.h"

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

@property (nonatomic, strong) XYJBankCardViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

/*
 * 选择器相关属性
 */
@property (nonatomic, strong) UIView *pickerBackgroundView;
@property (nonatomic, strong) UITapGestureRecognizer *pickerViewTap;
@property (nonatomic, strong) UIToolbar *pickerToolBar;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UITapGestureRecognizer *hiddenKeyboardTap;

@end

@implementation XYJAddBankCardViewController

#pragma mark - initialize

- (instancetype)initWithData:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if (dict) {
            _viewModel = [[XYJBankCardViewModel alloc] initWithData:dict type:XYJBankCardViewModelTypeEdit];
        } else {
            _viewModel = [[XYJBankCardViewModel alloc] initWithData:nil type:XYJBankCardViewModelTypeAddNew];
        }
        
        __weak __typeof(self)weakSelf = self;
        [_viewModel setCompleteHandler:^(BOOL success) {
            if (success) {
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willEnterBackground:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}

- (instancetype)init {
    self = [self initWithData:nil];
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XYJColor(0xf4f4f4);
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [cancelItem setTintColor:XYJColor(0x4c4c4c)];
    [saveItem setTintColor:XYJColor(0x4c4c4c)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.rightBarButtonItem = saveItem;
    
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

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XYJ_ScreenWidth, XYJ_ScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = XYJColor(0xf4f4f4);
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
        _pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, XYJ_ScreenHeight, XYJ_ScreenWidth, pickerToolbarHeight)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(hiddenPicker:)];
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
        _pickerView.frame = CGRectMake(0, XYJ_ScreenHeight, XYJ_ScreenWidth, pickerHeight);
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
    [self.viewModel save];
}

- (void)hiddenKeyboard {
    [self.view endEditing:YES];
}

- (void)showPicker {
    self.pickerBackgroundView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerToolBar.frame = CGRectMake(0, XYJ_ScreenHeight - pickerHeight - pickerToolbarHeight, XYJ_ScreenWidth, pickerToolbarHeight);
        self.pickerView.frame = CGRectMake(0, XYJ_ScreenHeight - pickerHeight, XYJ_ScreenWidth, pickerHeight);
    } completion:nil];
}

- (void)hiddenPicker:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerToolBar.frame = CGRectMake(0, XYJ_ScreenHeight, XYJ_ScreenWidth, pickerToolbarHeight);
        self.pickerView.frame = CGRectMake(0, XYJ_ScreenHeight, XYJ_ScreenWidth, pickerHeight);
    } completion:^(BOOL finished) {
        self.pickerBackgroundView.hidden = YES;
    }];
}

- (void)creditCardSwitch:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    [self.viewModel creditCard:aSwitch.isOn];
}

#pragma mark - NSNotification

- (void)keyboardWillShow:(NSNotification *)notification {
    [self.view addGestureRecognizer:self.hiddenKeyboardTap];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.view removeGestureRecognizer:self.hiddenKeyboardTap];
}

- (void)willEnterBackground:(NSNotification *)notification {
    [self save];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger row = textField.tag - kTextFieldTagPlus;
    if (self.viewModel.type == XYJBankCardViewModelTypeEdit && row == 1) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger row = textField.tag - kTextFieldTagPlus;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.viewModel inputData:textField.text atIndexPath:indexPath];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger row = textField.tag - kTextFieldTagPlus;
    if (self.viewModel.type == XYJBankCardViewModelTypeAddNew && row == 1) {
        return [string xyj_isPureNumber];
    }
    return YES;
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat originOffset = self.tableView.contentOffset.y;
        [self.tableView setContentOffset:CGPointMake(0, originOffset+42+10)];
    });
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.viewModel inputData:textView.text atIndexPath:indexPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView setContentOffset:CGPointMake(0, -64)];
    });
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel sectionForTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel rowForTableAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = [self.viewModel titleAtIndexPath:indexPath];
    NSString *key = [self.viewModel keyAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *cellRow0Identifier = @"cellRow0Identifier";
            XYJPickerCell *cell = (XYJPickerCell *)[tableView dequeueReusableCellWithIdentifier:cellRow0Identifier];
            if (cell == nil) {
                cell = [[XYJPickerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cellRow0Identifier];
            }
            [cell setLeftLabelText:title
                    rightLabelText:[self.viewModel selectedBankName]];
            return cell;
        } else if (indexPath.row == 2) {
            static NSString *cellRow2Identifier = @"cellRow2Identifier";
            XYJSwitchCell *cell = (XYJSwitchCell *)[tableView dequeueReusableCellWithIdentifier:cellRow2Identifier];
            if (cell == nil) {
                cell = [[XYJSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellRow2Identifier];
                [cell.aSwitch addTarget:self action:@selector(creditCardSwitch:) forControlEvents:UIControlEventValueChanged];
            }
            [cell setLeftLabelText:title
                          switchOn:[self.viewModel isCreditCard]];
            return cell;
        } else {
            static NSString *cellIdentifier = @"cellIdentifier";
            XYJTextFieldCell *cell = (XYJTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[XYJTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellIdentifier];
                [cell setTextFieldDelegate:self];
            }
            UIKeyboardType type = [self.viewModel.keyboardTypeDict[key] integerValue];
            [cell setTextFieldTag:(indexPath.row + kTextFieldTagPlus)
                      placeholder:self.viewModel.placeholderDict[key]
                     keyboardTyep:type];
            [cell setLeftLabelText:title
                  textFieldContent:[self.viewModel inputDataAtIndexPath:indexPath]];
            return cell;
        }
        
    } else {
        static NSString *cellIdentifier2 = @"cellIdentifier2";
        XYJTextViewCell *cell = (XYJTextViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell == nil) {
            cell = [[XYJTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier2];
            cell.textView.delegate = self;
        }
        [cell setTextViewContent:[self.viewModel inputDataAtIndexPath:indexPath]];
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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYJ_ScreenWidth, 10)];
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYJ_ScreenWidth, 22)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 22)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = XYJColor(0x696969);
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
    return self.viewModel.pickerDataArray.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.viewModel.pickerDataArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return pickerRowHeight;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    [self.viewModel selectBankAtIndex:row];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

@end
