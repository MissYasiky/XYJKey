//
//  XYJAccountDetailViewController.h
//  key
//
//  Created by MissYasiky on 2021/3/5.
//  Copyright © 2021 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XYJAccount;

@interface XYJAccountDetailViewController : UIViewController

- (instancetype)initWithAccount:(XYJAccount *)account;

@end

NS_ASSUME_NONNULL_END