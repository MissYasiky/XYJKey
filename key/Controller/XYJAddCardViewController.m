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

@interface XYJAddCardViewController ()<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *customKeyArray;
@property (nonatomic, strong) NSArray *tableViewCells;

@end

@implementation XYJAddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ADD CARD";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
    [self initUI];
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
        [cellOne setTextForTitle:@"Bank Name" picker:@"招商银行"];
        
        XYJDetailLabelCell *cellTwo = [[XYJDetailLabelCell alloc] init];
        [cellTwo setTextForTitle:@"Account Number" content:nil placeHolder:@"请输入银行卡卡号"];
        
        XYJDetailLabelCell *cellThree = [[XYJDetailLabelCell alloc] init];
        [cellThree setTextForTitle:@"Valid Thru（Month/Year)" picker:@"09/12"];
        
        XYJDetailLabelCell *cellFour = [[XYJDetailLabelCell alloc] init];
        [cellFour setTextForTitle:@"CVV2" content:nil placeHolder:@"请输入三位安全码"];
        
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
    cell.didTapDeleteButton = ^(NSInteger row) {
        [weakSelf removeCustomKeyAtIndex:row];
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
