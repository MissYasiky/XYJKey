//
//  XYJBankCardDao.m
//  key
//
//  Created by MissYasiky on 2018/12/10.
//  Copyright © 2018 netease. All rights reserved.
//

#import "XYJBankCardDao.h"
#import "XYJCacheUtils.h"
#import <FMDB/FMDB.h>

NSString *const XYJBankCardID = @"cardID";
NSString *const XYJBankCardVersion = @"version";
NSString *const XYJBankName = @"bankName";
NSString *const XYJBankCreditCard = @"isCreditCard";
NSString *const XYJBankECardPassword = @"eCardPassword";
NSString *const XYJBankQueryPassword = @"queryPassword";
NSString *const XYJBankWithdrawalPassword = @"withdrawalPassword";
NSString *const XYJBankRemark = @"remark";
NSString *const XYJBankCreateTime = @"createTime";

NSString *const XYJAddNewBankCardNotification = @"XYJAddNewBankCardNotification";
NSString *const XYJEditBankCardNotification = @"XYJEditBankCardNotification";

typedef NS_ENUM(NSUInteger, XYJBankCardColumn) {
    XYJBankCardColumnID = 0,
    XYJBankCardColumnVersion,
    XYJBankCardColumnBankName,
    XYJBankCardColumnCreditCard,
    XYJBankCardColumnECardPassword,
    XYJBankCardColumnQueryPassword,
    XYJBankCardColumnWithdrawalPassword,
    XYJBankCardColumnRemark,
    XYJBankCardColumnCreateTime,
    XYJBankCardColumnTotalCount
};

static NSString* kBankCardColumnName[XYJBankCardColumnTotalCount];
static NSString* kBankCardColumnType[XYJBankCardColumnTotalCount];

static NSString * const kBankCardTable = @"bcCacheTable";

#define kSQLInteger   @"integer"
#define kSQLText      @"text"
#define kSQLDouble    @"real"

@interface XYJBankCardDao ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation XYJBankCardDao

#pragma mark - Life Cycle

- (instancetype) init {
    self = [super init];
    if (self) {
        kBankCardColumnName[XYJBankCardColumnID] = XYJBankCardID;
        kBankCardColumnType[XYJBankCardColumnID] = kSQLText;
        
        kBankCardColumnName[XYJBankCardColumnVersion] = XYJBankCardVersion;
        kBankCardColumnType[XYJBankCardColumnVersion] = kSQLInteger;
        
        kBankCardColumnName[XYJBankCardColumnBankName] = XYJBankName;
        kBankCardColumnType[XYJBankCardColumnBankName] = kSQLInteger;
        
        kBankCardColumnName[XYJBankCardColumnCreditCard] = XYJBankCreditCard;
        kBankCardColumnType[XYJBankCardColumnCreditCard] = kSQLInteger;
        
        kBankCardColumnName[XYJBankCardColumnECardPassword] = XYJBankECardPassword;
        kBankCardColumnType[XYJBankCardColumnECardPassword] = kSQLText;
        
        kBankCardColumnName[XYJBankCardColumnQueryPassword] = XYJBankQueryPassword;
        kBankCardColumnType[XYJBankCardColumnQueryPassword] = kSQLText;
        
        kBankCardColumnName[XYJBankCardColumnWithdrawalPassword] = XYJBankWithdrawalPassword;
        kBankCardColumnType[XYJBankCardColumnWithdrawalPassword] = kSQLText;
        
        kBankCardColumnName[XYJBankCardColumnRemark] = XYJBankRemark;
        kBankCardColumnType[XYJBankCardColumnRemark] = kSQLText;
        
        kBankCardColumnName[XYJBankCardColumnCreateTime] = XYJBankCreateTime;
        kBankCardColumnType[XYJBankCardColumnCreateTime] = kSQLDouble;
        
        [self createTable];
    }
    return self;
}

#pragma mark - Public

+ (instancetype)sharedDao {
    static dispatch_once_t onceToken;
    static XYJBankCardDao *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super alloc] init];
    });
    return instance;
}

- (void)closeDataBase {
    [self.queue close];
    [self setQueue:nil];
}

- (void)insertData:(NSDictionary *)aDict completionBlock:(void(^)(BOOL success))block {
    NSDictionary *dict = [self addVersion:[XYJCacheUtils cacheWritePreprocess:aDict]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.queue inDatabase:^(FMDatabase *db) {
            
            NSMutableString *params = [[NSMutableString alloc] init];
            NSMutableString *values = [[NSMutableString alloc] init];
            NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:0];
            
            NSArray *keys = [dict allKeys];
            for (int i=0; i<keys.count; i++) {
                NSString *key = keys[i];
                id object = [dict objectForKey:key];
                if (i > 0) {
                    [params appendFormat:@","];
                    [values appendFormat:@","];
                }
                [params appendFormat:@"%@", key];
                [values appendFormat:@"?"];
                [arguments addObject:object];
            }
            NSString *executeString = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)", kBankCardTable, params, values];
            
            BOOL success = [db executeUpdate:executeString withArgumentsInArray:arguments];
            if (success) {
                NSLog(@"插入数据成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:XYJAddNewBankCardNotification object:aDict];
            } else {
                NSLog(@"插入数据失败");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(success);
                }
            });
        }];
    });
}

- (void)getDataWithCompletionBlock:(void (^)(NSArray <NSDictionary *> *messages))block {
    [self getDataWithLimit:0 completionBlock:block];
}

- (void)getDataWithLimit:(NSUInteger)limit completionBlock:(void (^)(NSArray <NSDictionary *> *messages))block {
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.queue inDatabase:^(FMDatabase *db) {
            
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            NSString *executeString = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@", kBankCardTable, kBankCardColumnName[XYJBankCardColumnCreateTime]];
            if (limit <= 0) {
                executeString = [executeString stringByAppendingFormat:@" LIMIT %d", MAXINTERP];
            }
            executeString = [executeString stringByAppendingString:@" OFFSET 0"];
            
            NSInteger index = 0;
            FMResultSet *result = [db executeQuery:executeString];
            while ([result next]) {
                NSDictionary *data = [weakSelf convertDBResult:result];
                [dataArray addObject:data];
                index ++;
            }
            [result close];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(dataArray);
                }
            });
            
            if ([self needMigration:dataArray]) { // 数据迁移
                [weakSelf dataMigration:dataArray];
            }
        }];
    });
}

- (void)deleteDataWithId:(NSString *)dataId completionBlock:(void(^)(BOOL success))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.queue inDatabase:^(FMDatabase *db) {
            NSString *executeString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@", kBankCardTable, kBankCardColumnName[XYJBankCardColumnID], dataId];
            BOOL success = [db executeUpdate:executeString];
            if (success) {
                NSLog(@"删除数据成功");
            } else {
                NSLog(@"删除数据失败");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(success);
                }
            });
        }];
    });
}

/**
 清空数据表，重新批量插入数据
 @param newData 新数据
 */
- (void)dataMigration:(NSArray *)newData {
    // 写入数据库之前的处理：加版本号、加密、编码
    NSMutableArray *muArray = [NSMutableArray new];
    for (NSDictionary *aDict in newData) {
        NSDictionary *dict = [self addVersion:[XYJCacheUtils cacheWritePreprocess:aDict]];
        [muArray addObject:dict];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            NSString *executeString = [NSString stringWithFormat:@"DELETE FROM %@", kBankCardTable];
            BOOL success = [db executeUpdate:executeString];
            
            if (success) {
                for (NSDictionary *dict in muArray) {
                    NSMutableString *params = [[NSMutableString alloc] init];
                    NSMutableString *values = [[NSMutableString alloc] init];
                    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:0];
                    
                    NSArray *keys = [dict allKeys];
                    for (int i=0; i<keys.count; i++) {
                        NSString *key = keys[i];
                        id object = [dict objectForKey:key];
                        if (i > 0) {
                            [params appendFormat:@","];
                            [values appendFormat:@","];
                        }
                        [params appendFormat:@"%@", key];
                        [values appendFormat:@"?"];
                        [arguments addObject:object];
                    }
                    NSString *executeString = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)", kBankCardTable, params, values];
                    [db executeUpdate:executeString withArgumentsInArray:arguments];
                }
            }
        }];
    });
}

- (void)updateData:(NSDictionary *)aDict completionBlock:(void (^)(BOOL success))block {
    NSDictionary *dict = [XYJCacheUtils cacheWritePreprocess:aDict];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.queue inDatabase:^(FMDatabase *db) {
            
            NSMutableString *params = [[NSMutableString alloc] init];
            NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:0];
            
            NSArray *keys = [dict allKeys];
            for (int i=0; i<keys.count; i++) {
                NSString *key = keys[i];
                id object = [dict objectForKey:key];
                if (i > 0) {
                    [params appendFormat:@", "];
                }
                [params appendFormat:@"%@ = ?", key];
                [arguments addObject:object];
            }
            NSString *executeString = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = %@", kBankCardTable, params, kBankCardColumnName[XYJBankCardColumnID], dict[XYJBankCardID]];
            
            BOOL success = [db executeUpdate:executeString withArgumentsInArray:arguments];
            if (success) {
                NSLog(@"更新数据成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:XYJEditBankCardNotification object:aDict];
            } else {
                NSLog(@"更新数据失败");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(success);
                }
            });
        }];
    });
}

#pragma mark - Private

- (void)createTable {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [paths[0] stringByAppendingFormat:@"/bcCache.sqlite"];
    NSLog(@"dbPath: %@", dbPath);
    
    self.queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    __weak __typeof(self)weakSelf = self;
    [self.queue inDatabase:^(FMDatabase *db) {
        db.logsErrors = YES;
        
        NSMutableString *parameter = [[NSMutableString alloc] init];
        for (int i = 0; i < XYJBankCardColumnTotalCount; i++) {
            [parameter appendFormat:@"%@ %@", kBankCardColumnName[i], kBankCardColumnType[i]];
            
            if ([kBankCardColumnType[i] isEqualToString: kSQLInteger]) {
                [parameter appendString:@" DEFAULT 0"];
            }
            
            if (i < XYJBankCardColumnTotalCount - 1) {
                [parameter appendString:@", "];
            }
        }
        
        NSString *executeString = [NSString stringWithFormat:@"CREATE TABLE %@ (%@, PRIMARY KEY (%@))",
                                   kBankCardTable,
                                   parameter,
                                   kBankCardColumnName[XYJBankCardColumnID]
                                   ];
        BOOL isSuccess = [db executeUpdate:executeString];
        
        //如果表已经存在，把每一列插入一遍，保障数据库的升级
        if (isSuccess == NO) {
            for (int i = 0; i < XYJBankCardColumnTotalCount; i++) {
                [weakSelf addColumnToDB:db column:kBankCardColumnName[i] type:kBankCardColumnType[i]];
            }
        }
    }];
}
/**
 为数据库添加一列数据
 */
- (void)addColumnToDB:(FMDatabase *)aDB column:(NSString *)aColumn type:(NSString *)aType {
    NSString *executeString = [NSString stringWithFormat:@"alter table %@ add %@ %@", kBankCardTable, aColumn, aType];
    if ([aType isEqualToString:kSQLInteger]) {
        executeString = [executeString stringByAppendingString:@" DEFAULT 0"];
    }
    BOOL success = [aDB executeUpdate:executeString];
    if(success) {
        NSLog(@"Table %@ 新增 column %@ type %@ 成功", kBankCardTable, aColumn, aType);
    }
}

/**
 是否需要数据迁移，第一版数据没有version字段，默认值为0
 */
- (BOOL)needMigration:(NSArray *)dataArray {
    BOOL needMigration = NO;
    if ([dataArray count] > 0) {
        NSDictionary *dict = dataArray[0];
        needMigration = ([dict[XYJBankCardVersion] integerValue] == 0);
    }
    return needMigration;
}

/**
 将查询结果转换为 NSDictionary
 */
- (NSDictionary *)convertDBResult:(FMResultSet *)result {
    NSMutableDictionary *muDict = [NSMutableDictionary new];
    for (int i = 0; i< XYJBankCardColumnTotalCount; i++) {
        NSString *key = kBankCardColumnName[i];
        NSString *type = kBankCardColumnType[i];
        
        if ([type isEqualToString:kSQLInteger]) {
            long long object = [result longLongIntForColumn:key];
            [muDict setValue:@(object) forKey:key];
        } else if ([type isEqualToString:kSQLDouble]) {
            double object = [result doubleForColumn:key];
            [muDict setValue:@(object) forKey:key];
        } else {
            NSString *object = [result stringForColumn:key];
            [muDict setValue:object forKey:key];
        }
    }
    if ([muDict[XYJBankCardVersion] integerValue] == 0) { // 兼容旧版本
        NSDictionary *resultDict = [XYJCacheUtils cacheOldReadPreprocess:[muDict mutableCopy]];
        return resultDict;
    } else {
        NSDictionary *resultDict = [XYJCacheUtils cacheReadPreprocess:[muDict mutableCopy]];
        return resultDict;
    }
}

/**
 新增数据版本号
 */
- (NSDictionary *)addVersion:(NSDictionary *)aDict {
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] initWithDictionary:aDict];
    [muDict setObject:@(1) forKey:XYJBankCardVersion];
    return [muDict mutableCopy];
}

@end
