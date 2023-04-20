//
//  XYJCardDataBase.h
//  key
//
//  Created by MissYasiky on 2021/2/7.
//  Copyright © 2021 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XYJCard;

/// Card 数据库操作单例类
@interface XYJCardDataBase : NSObject

+ (instancetype)sharedDataBase;

/// 插入数据
- (BOOL)insertData:(XYJCard *)data;

/// 删除数据
- (BOOL)deleteDataWithCreateTime:(NSTimeInterval)createTime;

/// 读取全部数据
- (NSArray<XYJCard *> * _Nullable)getAllData;

@end

NS_ASSUME_NONNULL_END
