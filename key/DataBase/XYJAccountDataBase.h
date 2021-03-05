//
//  XYJAccountDataBase.h
//  key
//
//  Created by MissYasiky on 2021/3/5.
//  Copyright © 2021 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XYJAccount;

/// Account 数据库操作单例类
@interface XYJAccountDataBase : NSObject

+ (instancetype)sharedDataBase;

/// 插入数据
- (BOOL)insertData:(XYJAccount *)data;

/// 删除数据
- (BOOL)deleteDataWithCreateTime:(NSTimeInterval)createTime;

/// 读取全部数据
- (NSArray<XYJAccount *> * _Nullable)getAllData;

@end

NS_ASSUME_NONNULL_END
