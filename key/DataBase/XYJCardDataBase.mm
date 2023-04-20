//
//  XYJCardDataBase.m
//  key
//
//  Created by MissYasiky on 2021/2/7.
//  Copyright © 2021 netease. All rights reserved.
//

#import "XYJCardDataBase.h"
#import "XYJCard.h"
#import "XYJCard+WCTTableCoding.h"
#import <WCDB/WCDB.h>

// 数据库表名
static NSString *kCardDataBaseTableName = @"XYJCard";

@interface XYJCardDataBase ()

@property (nonatomic, strong) WCTDatabase *database;

@end

@implementation XYJCardDataBase

#pragma mark - 生命周期

+ (instancetype)sharedDataBase {
    static dispatch_once_t onceToken;
    static XYJCardDataBase *dataBase = nil;
    dispatch_once(&onceToken, ^{
        dataBase = [[XYJCardDataBase alloc] init];
    });
    return dataBase;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *path = [self databasePath];
        _database = [[WCTDatabase alloc] initWithPath:path];
        NSString *logMessage = [NSString stringWithFormat:@"数据库路径：\n%@", path];
        [self logForMessage:logMessage];
        
        BOOL result = [_database createTableAndIndexesOfName:kCardDataBaseTableName withClass:XYJCard.class];
        logMessage = [NSString stringWithFormat:@"初始化表格 %@ %@", kCardDataBaseTableName, result ? @"成功" : @"失败"];
        [self logForMessage:logMessage];
    }
    return self;
}

/// 数据库文件存放沙盒路径
- (NSString *)databasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
    NSString *path = [NSString stringWithFormat:@"%@/db_card.db", documentPath];
    return path;
}

#pragma mark - DataBase

- (WCTTable *)databaseTable {
    WCTTable *table = [self.database getTableOfName:kCardDataBaseTableName withClass:XYJCard.class];
    return table;
}

#pragma mark 数据库操作

- (BOOL)insertData:(XYJCard *)data {
    BOOL result = [self.database insertObject:data into:kCardDataBaseTableName];
    NSString *logMessage = [NSString stringWithFormat:@"插入数据\"%@\"%@", data, result ? @"成功" : @"失败"];
    [self logForMessage:logMessage];
    return result;
}

- (BOOL)deleteDataWithCreateTime:(NSTimeInterval)createTime {
    BOOL result = [self.database deleteObjectsFromTable:kCardDataBaseTableName where:XYJCard.createTime == createTime];
    NSString *logMessage = [NSString stringWithFormat:@"删除数据 createTime = %f %@", createTime, result ? @"成功" : @"失败"];
    [self logForMessage:logMessage];
    return result;
}

- (NSArray<XYJCard *> *)getAllData {
    WCTTable *table = [self databaseTable];
    NSArray<XYJCard *> *dataArray = [table getObjectsOrderBy:XYJCard.createTime.order(WCTOrderedDescending)];
    NSString *logMessage = [NSString stringWithFormat:@"获取所有数据 %@", dataArray];
    [self logForMessage:logMessage];
    return dataArray;
}

#pragma mark - Utils

/// 控制台日志统一打印方法
- (void)logForMessage:(NSString *)message {
    NSLog(@"【Card 数据库】%@: %@", kCardDataBaseTableName, message);
}

@end
