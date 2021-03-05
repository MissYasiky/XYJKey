//
//  XYJAccount.m
//  key
//
//  Created by MissYasiky on 2021/3/5.
//  Copyright © 2021 netease. All rights reserved.
//

#import "XYJAccount.h"
#import <WCDB/WCDB.h>

@implementation XYJAccount

// 数据库类名
WCDB_IMPLEMENTATION(XYJAccount)

// 数据库字段
WCDB_SYNTHESIZE(XYJAccount, createTime)
WCDB_SYNTHESIZE(XYJAccount, accountName)
WCDB_SYNTHESIZE(XYJAccount, externDict)

// 数据库关键字
WCDB_PRIMARY(XYJAccount, createTime)

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _createTime = floor([[NSDate date] timeIntervalSince1970] * 1000);
    }
    return self;
}

#pragma mark - description

- (NSString *)description {
    return [NSString stringWithFormat:@"账户%@: %@", _accountName, _externDict];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p, \"账户%@: %@\">", [self class], self, _accountName, _externDict];
}

@end
