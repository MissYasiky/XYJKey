//
//  XYJViewController.m
//  key
//
//  Created by MissYasiky on 2018/11/2.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJViewController.h"
#import "XYJAddBankCardViewController.h"

@interface XYJViewController ()

@end

@implementation XYJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XYJColor(0xf4f4f4, 1.0);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBankCard)];
    [item setTintColor:XYJColor(0x4c4c4c, 1.0)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addBankCard {
    XYJAddBankCardViewController *vctrl = [[XYJAddBankCardViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vctrl];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}


@end
