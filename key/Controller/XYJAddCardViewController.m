//
//  XYJAddCardViewController.m
//  key
//
//  Created by MissYasiky on 2020/2/15.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJAddCardViewController.h"
#import "XYJDetailLabelCell.h"
#import "XYJSimpleLabelCell.h"
#import "XYJCustomKeyCell.h"
#import "XYJCardModel.h"

@interface XYJAddCardViewController ()<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *customKeyArray;
@property (nonatomic, strong) NSArray *tableViewCells;

/// 通过手势隐藏键盘相关属性
// 键盘是否显示
@property (nonatomic, assign) BOOL showKeyboard;
// 键盘 frame 的 origin 的 y 值
@property (nonatomic, assign) CGFloat keyboardOriginY;
// 显示键盘时，拖动手势的拖动起始点
@property (nonatomic, assign) CGPoint dragBeginPoint;
// 显示键盘时，拖动手势的拖动结束点
@property (nonatomic, assign) CGPoint dragEndPoing;

@end

@implementation XYJAddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ADD CARD";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
    [self initUI];
    [self addNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization

- (void)initNavigationBar {
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"nav_btn_close"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"nav_btn_close_highlight"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.saveButton];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
}

#pragma mark - Getter & Setter

- (NSMutableArray *)customKeyArray {
    if (!_customKeyArray) {
        _customKeyArray = [[NSMutableArray alloc] init];
    }
    return _customKeyArray;
}

- (NSArray *)tableViewCells {
    if (!_tableViewCells) {
        XYJDetailLabelCell *cellOne = [[XYJDetailLabelCell alloc] init];
        [cellOne setTextForTitle:@"Bank Name" content:nil placeHolder:@"请输入银行名称"];
        
        XYJDetailLabelCell *cellTwo = [[XYJDetailLabelCell alloc] init];
        [cellTwo setTextForTitle:@"Account Number" content:nil placeHolder:@"请输入银行卡卡号"];
        cellTwo.textFieldStyle = XYJDetailLabelCellTextFieldStyleNumber;
        
        XYJDetailLabelCell *cellThree = [[XYJDetailLabelCell alloc] init];
        [cellThree setTextForTitle:@"Valid Thru（MMYY)" content:nil placeHolder:@"请输入四位银行卡有效期"];
        cellThree.textFieldStyle = XYJDetailLabelCellTextFieldStyleDate;
        
        XYJDetailLabelCell *cellFour = [[XYJDetailLabelCell alloc] init];
        [cellFour setTextForTitle:@"CVV2" content:nil placeHolder:@"请输入三位安全码"];
        cellFour.textFieldStyle = XYJDetailLabelCellTextFieldStyleCVV;
        
        XYJSimpleLabelCell *cellFive = [[XYJSimpleLabelCell alloc] init];
        [cellFive setCellIconImageName:@"list_icon_card"];
        [cellFive setLabelText:@"Credit Card"];
        cellFive.style = XYJSimpleLabelCellCheck;
        
        XYJSimpleLabelCell *cellSix = [[XYJSimpleLabelCell alloc] init];
        [cellSix setCellIconImageName:@"list_icon_profile"];
        [cellSix setLabelText:@"My Own"];
        cellSix.style = XYJSimpleLabelCellCheck;
        
        _tableViewCells = @[cellOne, cellTwo, cellThree, cellFour, cellFive, cellSix];
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return _tableViewCells;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat originY = XYJ_StatusBarHeight + XYJ_NavigationBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, XYJ_ScreenWidth, XYJ_ScreenHeight - originY - 88) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsMultipleSelection = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYJ_ScreenWidth, 35)];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(25, 35-14, XYJ_ScreenWidth-25*2, 14);
        label.text = @"Custom Key";
        label.font = [UIFont fontWithName:XYJ_Regular_Font size:11];
        label.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color alpha:0.5];
        [_headerView addSubview:label];
    }
    return _headerView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_saveButton setBackgroundColor:[XYJColorUtils colorWithHexString:XYJ_Theme_Blue_Color]];
        _saveButton.layer.shadowColor = [XYJColorUtils colorWithHexString:XYJ_Theme_Blue_Color].CGColor;
        _saveButton.layer.shadowOffset = CGSizeMake(0, -6);
        _saveButton.layer.shadowOpacity = 0.2;
        _saveButton.layer.shadowRadius = 10;
        
        NSDictionary *titleAttributes = @{NSFontAttributeName:[UIFont fontWithName:XYJ_Bold_Font size:16],
                                          NSForegroundColorAttributeName:[UIColor whiteColor],
                                          NSKernAttributeName:@(3),
        };
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"icon_save"];
        attachment.bounds = CGRectMake(0, -4, 24, 20);
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:@"   SAVE" attributes:titleAttributes];
        [string appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        [string appendAttributedString:attributedText];
        [_saveButton setAttributedTitle:string forState:UIControlStateNormal];
        [_saveButton setTitleEdgeInsets:UIEdgeInsetsMake(-16, 0, 16, 0)];
        
        CGFloat height = 88;
        _saveButton.frame = CGRectMake(0, XYJ_ScreenHeight - height, XYJ_ScreenWidth, height);
    }
    return _saveButton;
}

#pragma mark - Action

- (void)closeButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonAction {
    XYJCardModel *model = [[XYJCardModel alloc] init];
    for (int i = 0; i < 4; i++) {
        XYJDetailLabelCell *cell = self.tableViewCells[i];
        if (i == 0) {
            model.bankName = cell.enterContent;
        } else if (i == 1) {
            model.accountNum = cell.enterContent;
        } else if (i == 2) {
            model.validThru = cell.enterContent;
        } else {
            model.cvv2 = cell.enterContent;
        }
    }
    
    for (NSIndexPath *selectIndexPath in [self.tableView indexPathsForSelectedRows]) {
        if (selectIndexPath.row == 4) {
            model.creditCard = 1;
        } else if (selectIndexPath.row == 5) {
            model.myOwn = 1;
        }
    }
    
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] initWithCapacity:[self.customKeyArray count]];
    for (NSArray *customKeyValue in self.customKeyArray) {
        if ([customKeyValue count] < 2) {
            continue;
        }
        NSString *key = customKeyValue[0];
        NSString *value = customKeyValue[1];
        if (!key || ![key isKindOfClass:[NSString class]] || key.length == 0 ||
            !value || ![value isKindOfClass:[NSString class]] || value.length == 0) {
            continue;
        }
        muDict[key] = value;
    }
    model.externDict = [muDict copy];
}

#pragma mark - Private

- (void)addCustomKey {
    NSArray *keyValue = @[@"", @""];
    [self.customKeyArray addObject:keyValue];
    NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:[self.customKeyArray count] - 1 inSection:1];
    [self.tableView insertRowsAtIndexPaths:@[addIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)removeCustomKeyAtIndex:(NSInteger)row {
    [self.customKeyArray removeObjectAtIndex:row];
    [self.tableView reloadData];
}

- (void)tableViewScrollForIndex:(NSInteger)row {
    [self.tableView setContentOffset:CGPointMake(0, 44 + 102 * 3 + row * 67)];
}

#pragma mark - NSNotification

- (void)keyboardWillShow:(NSNotification *)notif {
    self.showKeyboard = YES;
}

- (void)keyboardWillHide:(NSNotification *)notif {
    self.showKeyboard = NO;
}

- (void)keyboardDidChangeFrame:(NSNotification *)notif {
    CGRect kbFrameEnd = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardOriginY = kbFrameEnd.origin.y;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!self.showKeyboard) {
        return;
    }
    
    CGPoint dragBeginPoint = [scrollView.panGestureRecognizer locationInView:self.view];
    if (dragBeginPoint.y >= self.keyboardOriginY) {
        return;
    }
    
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:self.view];
    if (velocity.y <= 0) {
        return;
    }
    
    self.dragBeginPoint = dragBeginPoint;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!self.showKeyboard) {
        return;
    }
    
    if (self.dragBeginPoint.y == 0) {
        return;
    }
    
    CGPoint dragEndPoint = [scrollView.panGestureRecognizer locationInView:self.view];
    if (dragEndPoint.y < self.keyboardOriginY) {
        self.dragBeginPoint = CGPointMake(0, 0);
        return;
    }
    
    [self.view endEditing:YES];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.tableViewCells count];
    } else {
        return [self.customKeyArray count] + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (indexPath.row < 4) ? [XYJDetailLabelCell height] : [XYJSimpleLabelCell height];
    } else {
        return [XYJCustomKeyCell height];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    } else {
        return 35;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    } else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return self.headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYJ_ScreenWidth, 30)];;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.tableViewCells[indexPath.row];
    }
    
    static NSString *cellIdentifier = @"cellIdentifier";
    XYJCustomKeyCell *cell = (XYJCustomKeyCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XYJCustomKeyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    __weak __typeof(self) weakSelf = self;
    cell.indexIdentifier = [NSString stringWithFormat:@"%03zd", indexPath.row];
    cell.style = (indexPath.row == [self.customKeyArray count]) ? XYJCustomKeyCellStyleAddKey : XYJCustomKeyCellStyleKeyValue;
    
    if (indexPath.row == [self.customKeyArray count]) {
        return cell;
    }
    
    NSArray *object = self.customKeyArray[indexPath.row];
    [cell setKey:object[0] value:object[1]];
    cell.didTapDeleteButton = ^(NSInteger row) {
        [weakSelf removeCustomKeyAtIndex:row];
    };
    cell.didTextFieldBeginEditing = ^(NSInteger row) {
        [weakSelf tableViewScrollForIndex:row];
    };
    cell.didTextFieldChanged = ^(NSInteger row, NSString * _Nullable keyString, NSString * _Nullable valueString) {
        NSArray *array = @[keyString ?: @"", valueString ?: @""];
        [weakSelf.customKeyArray replaceObjectAtIndex:row withObject:array];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && indexPath.row < 4) ||
        indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"bank picker");
        } else if (indexPath.row == 2) {
            NSLog(@"data picker");
        }
    } else {
        if (indexPath.row == [self.customKeyArray count]) {
            [self addCustomKey];
        }
    }
}

@end
