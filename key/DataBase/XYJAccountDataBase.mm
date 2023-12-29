//
//  XYJAccountDataBase.m
//  key
//
//  Created by MissYasiky on 2021/3/5.
//  Copyright © 2021 netease. All rights reserved.
//

#import "XYJAccountDataBase.h"
#import "XYJAccount.h"
#import "XYJAccount+WCTTableCoding.h"
#import <WCDB/WCDB.h>

// 数据库表名
static NSString *kAccountDataBaseTableName = @"XYJAccount";

@interface XYJAccountDataBase ()

@property (nonatomic, strong) WCTDatabase *database;

@end

@implementation XYJAccountDataBase

#pragma mark - 生命周期

+ (instancetype)sharedDataBase {
    static dispatch_once_t onceToken;
    static XYJAccountDataBase *dataBase = nil;
    dispatch_once(&onceToken, ^{
        dataBase = [[XYJAccountDataBase alloc] init];
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
        
        BOOL result = [_database createTableAndIndexesOfName:kAccountDataBaseTableName withClass:XYJAccount.class];
        logMessage = [NSString stringWithFormat:@"初始化表格 %@ %@", kAccountDataBaseTableName, result ? @"成功" : @"失败"];
        [self logForMessage:logMessage];
    }
    return self;
}

/// 数据库文件存放沙盒路径
- (NSString *)databasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
    NSString *path = [NSString stringWithFormat:@"%@/db_account.db", documentPath];
    return path;
}

#pragma mark - DataBase

- (WCTTable *)databaseTable {
    WCTTable *table = [self.database getTableOfName:kAccountDataBaseTableName withClass:XYJAccount.class];
    return table;
}

#pragma mark 数据库操作

- (BOOL)insertData:(XYJAccount *)data {
    BOOL result = [self.database insertObject:data into:kAccountDataBaseTableName];
    NSString *logMessage = [NSString stringWithFormat:@"插入数据\"%@\"%@", data, result ? @"成功" : @"失败"];
    [self logForMessage:logMessage];
    return result;
}

- (BOOL)deleteDataWithCreateTime:(NSTimeInterval)createTime {
    BOOL result = [self.database deleteObjectsFromTable:kAccountDataBaseTableName where:XYJAccount.createTime == createTime];
    NSString *logMessage = [NSString stringWithFormat:@"删除数据 createTime = %f %@", createTime, result ? @"成功" : @"失败"];
    [self logForMessage:logMessage];
    return result;
}

- (NSArray<XYJAccount *> *)getAllData {
    WCTTable *table = [self databaseTable];
    NSArray<XYJAccount *> *dataArray = [table getObjectsOrderBy:XYJAccount.createTime.order(WCTOrderedDescending)];
    NSString *logMessage = [NSString stringWithFormat:@"获取所有数据 %@", dataArray];
    [self logForMessage:logMessage];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (XYJAccount *data in dataArray) {
            [[XYJAccountDataBase sharedDataBase] updataData:data];
        }
    });
    
    return dataArray;
}

- (void)updataData:(XYJAccount *)data {
    if (data.externDict != nil) {
        data.externString = [XYJDailyTools jsonStringWithJSONObject:data.externDict];
        NSLog(@"convert data %@ externInfo (%@)", data, data.externString);
        BOOL success = [self.database updateRowsInTable:kAccountDataBaseTableName onProperty:XYJAccount.externString withObject:data where:XYJAccount.createTime == data.createTime];
        if (!success) {
            NSLog(@"updata data failure");
        }
    }
}

#pragma mark - Utils

/// 控制台日志统一打印方法
- (void)logForMessage:(NSString *)message {
    NSLog(@"【Account 数据库】%@: %@", kAccountDataBaseTableName, message);
}

@end
