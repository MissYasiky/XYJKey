//
//  XYJAccount.h
//  key
//
//  Created by MissYasiky on 2021/3/5.
//  Copyright © 2021 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 账户数据模型
@interface XYJAccount : NSObject

/// 数据创建时间，数据库关键字段，不可为空
@property (nonatomic, assign) NSTimeInterval createTime;

/// 账户名称，不可为空
@property (nonatomic, copy) NSString *accountName;

/// 自定义信息，用于各种其他信息补充
@property (nonatomic, copy) NSDictionary * _Nullable externDict;

/// externDict的jsonString
@property (nonatomic, strong) NSString * _Nullable externString;

@end

NS_ASSUME_NONNULL_END
