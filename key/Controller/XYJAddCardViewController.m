//
//  XYJAddCardViewController.m
//  key
//
//  Created by MissYasiky on 2020/2/15.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJAddCardViewController.h"

@interface XYJAddCardViewController ()<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XYJAddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ADD CARD";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
    [self initTableView];
    [self initSaveButton];
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

- (void)initTableView {
    CGFloat originY = XYJ_StatusBarHeight + XYJ_NavigationBarHeight;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, XYJ_ScreenWidth, XYJ_ScreenHeight - originY - 88) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)initSaveButton {
    self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveButton setBackgroundColor:[XYJColorUtils colorWithHexString:XYJ_Theme_Blue_Color]];
    self.saveButton.layer.shadowColor = [XYJColorUtils colorWithHexString:XYJ_Theme_Blue_Color].CGColor;
    self.saveButton.layer.shadowOffset = CGSizeMake(0, -6);
    self.saveButton.layer.shadowOpacity = 0.2;
    self.saveButton.layer.shadowRadius = 10;
    
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
    [self.saveButton setAttributedTitle:string forState:UIControlStateNormal];
    [self.saveButton setTitleEdgeInsets:UIEdgeInsetsMake(-16, 0, 16, 0)];
    
    CGFloat height = 88;
    self.saveButton.frame = CGRectMake(0, XYJ_ScreenHeight - height, XYJ_ScreenWidth, height);
    [self.view addSubview:self.saveButton];
}

#pragma mark - Action

- (void)closeButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonAction {
    
}

#pragma mark - UITableView DataSource & Delegate

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
