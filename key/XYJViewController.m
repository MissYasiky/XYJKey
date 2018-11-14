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
    self.view.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf4/255.0 blue:0xf4/255.0 alpha:1.0];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBankCard)];
    [item setTintColor:[UIColor colorWithRed:0x4c/255.0 green:0x4c/255.0 blue:0x4c/255.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addBankCard {
    XYJAddBankCardViewController *vctrl = [[XYJAddBankCardViewController alloc] init];
    [self.navigationController pushViewController:vctrl animated:YES];
}


@end
