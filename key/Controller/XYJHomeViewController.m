//
//  XYJHomeViewController.m
//  key
//
//  Created by MissYasiky on 2020/1/31.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJHomeViewController.h"
#import "XYJMenuViewController.h"

@interface XYJHomeViewController ()

@end

@implementation XYJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
}

#pragma mark - Initialization

- (void)initNavigationBar {
    self.title = @"MY KEY";
    
    // 菜单页按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"nav_btn_menu"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    UIBarButtonItem *menuItem =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = menuItem;

    // 返回按钮统一配置
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    UIImage *backImage = [UIImage imageNamed:@"nav_btn_back"];
    self.navigationController.navigationBar.backIndicatorImage = backImage;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage;
    
    // 设置手势返回上一页
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Action

- (void)menuButtonAction {
    XYJMenuViewController *vctrl = [[XYJMenuViewController alloc] init];
    [self.navigationController pushViewController:vctrl animated:YES];
}

@end
