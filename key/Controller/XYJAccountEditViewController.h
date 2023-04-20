//
//  XYJAccountEditViewController.h
//  key
//
//  Created by MissYasiky on 2021/3/5.
//  Copyright © 2021 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XYJAccount;

/// 新增/编辑账户页面
@interface XYJAccountEditViewController : UIViewController

/// 初始化方法
/// @param account 为空代表初始化新账户页面，不为空代表需要编辑的账户数据
- (instancetype)initWithAccount:(XYJAccount * _Nullable)account;

@end

NS_ASSUME_NONNULL_END
