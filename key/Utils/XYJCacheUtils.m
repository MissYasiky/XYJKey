//
//  XYJCacheUtils.m
//  key
//
//  Created by MissYasiky on 2018/11/25.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJCacheUtils.h"

static NSString *kBandCardFile = @"BCCache";

NSString * const XYJBankNameKey = @"银行";
NSString * const XYJBankAccountKey = @"账号";
NSString * const XYJBankCreditCardKey = @"信用卡";
NSString * const XYJEBankPasswordKey = @"网银密码";
NSString * const XYJBankQueryPasswordKey = @"查询密码";
NSString * const XYJBankWithdrawalPasswordKey = @"取款密码";
NSString * const XYJBankRemarkKey = @"备注";

@implementation XYJCacheUtils

+ (NSArray *)bankNameArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XYJDataConstant" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *array = dict[@"bankName"];
    return array;
}

+ (NSString *)bankCardPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths[0] stringByAppendingFormat:@"/%@.txt", kBandCardFile];
    return documentPath;
}

+ (BOOL)writeBankCardToCache:(NSDictionary *)dict {
    NSString *path = [XYJCacheUtils bankCardPath];
    NSError *error = nil;
    NSMutableArray *muArray = [NSMutableArray new];
    NSData *cacheData = [[NSData alloc] initWithContentsOfFile:path];
    if (cacheData) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:cacheData
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
        [muArray addObjectsFromArray:array];
    }
    [muArray addObject:dict];
    NSData *data = [NSJSONSerialization dataWithJSONObject:muArray options:kNilOptions error:&error];
    BOOL success = [data writeToFile:path atomically:YES];
    return success;
}

+ (NSArray *)bankCardFromCache {
    NSString *path = [XYJCacheUtils bankCardPath];
    NSData *cacheData = [[NSData alloc] initWithContentsOfFile:path];
    if (cacheData == nil) {
        return @[];
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:cacheData
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];
    return array;
}

+ (BOOL)deleteBankCardAtIndex:(NSInteger)index {
    NSMutableArray *muArray = [[NSMutableArray alloc] initWithArray:[self bankCardFromCache]];
    [muArray removeObjectAtIndex:index];
    
    NSString *path = [XYJCacheUtils bankCardPath];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:muArray options:kNilOptions error:&error];
    BOOL success = [data writeToFile:path atomically:YES];
    return success;
}

@end
