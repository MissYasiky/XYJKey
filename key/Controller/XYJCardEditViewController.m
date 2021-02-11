//
//  XYJCardEditViewController.m
//  key
//
//  Created by MissYasiky on 2020/2/15.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCardEditViewController.h"

/// UI
#import "XYJDetailLabelCell.h"
#import "XYJSimpleLabelCell.h"
#import "XYJCustomKeyCell.h"

/// 数据
#import "XYJCard.h"
#import "XYJCardDataBase.h"

@interface XYJCardEditViewController ()<
UITableViewDataSource,
UITableViewDelegate
>

#pragma mark UI
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *tableViewCells;

#pragma mark 数据
// 是否编辑模式，默认为NO
@property (nonatomic, assign) BOOL editMode;
// editMode为YES时不为0，原数据创建时间，数据库关键字段
@property (nonatomic, assign) NSTimeInterval editedCardcreateTime;
// 核心数据，编辑模式时通过页面初始化带进来
@property (nonatomic, strong) XYJCard *card;
@property (nonatomic, strong) NSMutableArray *customKeyArray;

#pragma mark 键盘
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

@implementation XYJCardEditViewController

#pragma mark - Life Cycle

- (instancetype)initWithCard:(XYJCard *)card {
    self = [super init];
    if (self) {
        if (card) { // 编辑模式下，保存原的数据库关键字，用于删除旧数据，重新生成新的关键字字段，用于编辑后重新写入数据库
            self.card = card;
            self.editMode = YES;
            self.editedCardcreateTime = card.createTime;
            self.card.createTime = [[NSDate date] timeIntervalSince1970];
        } else {
            self.card = [[XYJCard alloc] init];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.editMode ? @"EDIT CARD" : @"ADD CARD";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self initUI];
    [self initNavigationBar];
    [self addNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization

- (void)initData {
    if (self.card.externDict && [self.card.externDict count] > 0) {
        NSDictionary *externDict = self.card.externDict;
        NSInteger customKeyCount = [externDict count];
        self.customKeyArray = [[NSMutableArray alloc] initWithCapacity:customKeyCount];
        for (NSString *key in externDict.allKeys) {
            NSArray *array = @[key, externDict[key]];
            [self.customKeyArray addObject:[array copy]];
        }
    } else {
        self.customKeyArray = [[NSMutableArray alloc] init];
    }
}

- (void)initUI {
    [self initCellWithData];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.saveButton];
    
    if (self.card.isCreditCard) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if (self.card.isOwn) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)initCellWithData {
    XYJCard *card = self.editMode ? self.card : nil;
    
    XYJDetailLabelCell *cellOne = [[XYJDetailLabelCell alloc] init];
    [cellOne setTextForTitle:@"Bank Name" content:card.bankName placeHolder:@"请输入银行名称"];
    
    XYJDetailLabelCell *cellTwo = [[XYJDetailLabelCell alloc] init];
    NSString *accountNum = [card.accountNum xyj_seperateEveryFourNumber];
    [cellTwo setTextForTitle:@"Account Number" content:accountNum placeHolder:@"请输入银行卡卡号"];
    cellTwo.textFieldStyle = XYJDetailLabelCellTextFieldStyleNumber;
    
    XYJDetailLabelCell *cellThree = [[XYJDetailLabelCell alloc] init];
    [cellThree setTextForTitle:@"Valid Thru（MMYY)" content:card.validThru placeHolder:@"请输入四位银行卡有效期"];
    cellThree.textFieldStyle = XYJDetailLabelCellTextFieldStyleDate;
    
    XYJDetailLabelCell *cellFour = [[XYJDetailLabelCell alloc] init];
    [cellFour setTextForTitle:@"CVV2" content:card.cvv2 placeHolder:@"请输入三位安全码"];
    cellFour.textFieldStyle = XYJDetailLabelCellTextFieldStyleCVV;
    
    XYJSimpleLabelCell *cellFive = [[XYJSimpleLabelCell alloc] init];
    [cellFive setCellIconImageName:@"list_icon_card"];
    [cellFive setLabelText:@"Credit Card"];
    cellFive.style = XYJSimpleLabelCellCheck;
    
    XYJSimpleLabelCell *cellSix = [[XYJSimpleLabelCell alloc] init];
    [cellSix setCellIconImageName:@"list_icon_profile"];
    [cellSix setLabelText:@"My Own"];
    cellSix.style = XYJSimpleLabelCellCheck;
    
    self.tableViewCells = @[cellOne, cellTwo, cellThree, cellFour, cellFive, cellSix];
}

- (void)initNavigationBar {
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"nav_btn_close"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"nav_btn_close_highlight"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = item;
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

- (XYJCard *)card {
    if (!_card) {
        _card = [[XYJCard alloc] init];
    }
    return _card;
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
    [self updateCard];
    
    BOOL success = [[XYJCardDataBase sharedDataBase] insertData:self.card];
    if (success) {
        if (self.editMode) {
            [[XYJCardDataBase sharedDataBase] deleteDataWithCreateTime:self.editedCardcreateTime];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"保存数据失败");
    }
}

// 根据页面填写数据更新card数据模型
- (void)updateCard {
    for (int i = 0; i < 4; i++) {
        XYJDetailLabelCell *cell = self.tableViewCells[i];
        if (i == 0) {
            self.card.bankName = cell.enterContent;
        } else if (i == 1) {
            NSString *accountNum = [cell.enterContent stringByReplacingOccurrencesOfString:@" " withString:@""];
            self.card.accountNum = accountNum;
        } else if (i == 2) {
            self.card.validThru = cell.enterContent;
        } else {
            self.card.cvv2 = cell.enterContent;
        }
    }
    
    self.card.isCreditCard = self.card.isOwn = NO;
    for (NSIndexPath *selectIndexPath in [self.tableView indexPathsForSelectedRows]) {
        if (selectIndexPath.row == 4) {
            self.card.isCreditCard = 1;
        } else if (selectIndexPath.row == 5) {
            self.card.isOwn = 1;
        }
    }
    
    if (self.customKeyArray && [self.customKeyArray count] > 0) {
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
        self.card.externDict = [muDict copy];
    }
}

#pragma mark - Keyboard
#pragma mark NSNotification

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

#pragma mark UIScrollView Delegate

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
        return [self.customKeyArray count] + 1; // +1是用于在列表末尾显示添加按钮空白行
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
    } else { // 自定义数据字段
        static NSString *cellIdentifier = @"cellIdentifier";
        XYJCustomKeyCell *cell = (XYJCustomKeyCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[XYJCustomKeyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        __weak __typeof(self) weakSelf = self;
        cell.indexIdentifier = [NSString stringWithFormat:@"%03zd", indexPath.row];
        
        if (indexPath.row < [self.customKeyArray count]) { // 填写自定义字段 cell
            cell.style = XYJCustomKeyCellStyleKeyValue;
            
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
        } else { // 新增自定义字段 cell
            cell.style = XYJCustomKeyCellStyleAddKey;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == [self.customKeyArray count]) {
        [self addCustomKey];
    }
}

#pragma mark - Custom Key

- (void)addCustomKey {
    NSArray *keyValue = @[@"", @""];
    [self.customKeyArray addObject:keyValue];
    NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:[self.customKeyArray count] - 1 inSection:1];
    [self.tableView insertRowsAtIndexPaths:@[addIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)removeCustomKeyAtIndex:(NSInteger)row {
    if (self.customKeyArray.count <= row) {
        return;
    }
    [self.customKeyArray removeObjectAtIndex:row];
    [self.tableView reloadData];
}

- (void)tableViewScrollForIndex:(NSInteger)row {
    [self.tableView setContentOffset:CGPointMake(0, 44 + 102 * 3 + row * 67)];
}

@end
