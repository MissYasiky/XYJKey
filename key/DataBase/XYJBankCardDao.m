//
//  XYJBankCardDao.m
//  key
//
//  Created by MissYasiky on 2018/12/10.
//  Copyright © 2018 netease. All rights reserved.
//

#import "XYJBankCardDao.h"
#import <FMDB/FMDB.h>

NSString *const XYJBankCardID = @"cardID";
NSString *const XYJBankName = @"bankName";
NSString *const XYJBankCreditCard = @"isCreditCard";
NSString *const XYJBankECardPassword = @"eCardPassword";
NSString *const XYJBankQueryPassword = @"queryPassword";
NSString *const XYJBankWithdrawalPassword = @"withdrawalPassword";
NSString *const XYJBankRemark = @"remark";

typedef NS_ENUM(NSUInteger, XYJBankCardColumn) {
    XYJBankCardColumnID = 0,
    XYJBankCardColumnBankName,
    XYJBankCardColumnCreditCard,
    XYJBankCardColumnECardPassword,
    XYJBankCardColumnQueryPassword,
    XYJBankCardColumnWithdrawalPassword,
    XYJBankCardColumnRemark,
    XYJBankCardColumnTotalCount
};

static NSString* kBankCardColumnName[XYJBankCardColumnTotalCount];
static NSString* kBankCardColumnType[XYJBankCardColumnTotalCount];

static NSString * const kBankCardTable = @"bcCacheTable";

#define kSQLInteger   @"integer"
#define kSQLText      @"text"

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
        
        kBankCardColumnName[XYJBankCardColumnBankName] = XYJBankName;
        kBankCardColumnType[XYJBankCardColumnBankName] = kSQLText;
        
        kBankCardColumnName[XYJBankCardColumnCreditCard] = XYJBankCreditCard;
        kBankCardColumnType[XYJBankCardColumnCreditCard] = kSQLInteger;
        
        kBankCardColumnName[XYJBankCardColumnECardPassword] = XYJBankECardPassword;
        kBankCardColumnType[XYJBankCardColumnECardPassword] = kSQLText;
        
        kBankCardColumnName[XYJBankCardColumnQueryPassword] = XYJBankQueryPassword;
        kBankCardColumnType[XYJBankCardColumnQueryPassword] = kSQLInteger;
        
        kBankCardColumnName[XYJBankCardColumnWithdrawalPassword] = XYJBankWithdrawalPassword;
        kBankCardColumnType[XYJBankCardColumnWithdrawalPassword] = kSQLInteger;
        
        kBankCardColumnName[XYJBankCardColumnRemark] = XYJBankRemark;
        kBankCardColumnType[XYJBankCardColumnRemark] = kSQLText;
        
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

#pragma mark - Private

- (void)createTable {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [paths[0] stringByAppendingFormat:@"/bcCache.sqlite"];
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

//为数据库添加一列数据
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

// 将查询结果转换为 NSDictionary
- (NSDictionary *)convertDBResult:(FMResultSet *)result {
    NSMutableDictionary *muDict = [NSMutableDictionary new];
    for (int i = 0; i< XYJBankCardColumnTotalCount; i++) {
        NSString *key = kBankCardColumnName[i];
        NSString *type = kBankCardColumnType[i];
        
        if ([type isEqualToString:kSQLInteger]) {
            long long object = [result longLongIntForColumn:key];
            [muDict setValue:@(object) forKey:key];
        } else {
            NSString *object = [result stringForColumn:key];
            [muDict setValue:object forKey:key];
        }
    }
    return [muDict mutableCopy];
}

@end
