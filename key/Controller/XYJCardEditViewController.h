//
//  XYJCardEditViewController.h
//  key
//
//  Created by MissYasiky on 2020/2/15.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 新增/编辑银行卡页面
@interface XYJCardEditViewController : UIViewController

/// 初始化方法
/// @param card 为空代表初始化新建银行卡页面，不为空代表需要编辑的银行卡数据
- (instancetype)initWithCard:(Card * _Nullable)card;

@end

NS_ASSUME_NONNULL_END
