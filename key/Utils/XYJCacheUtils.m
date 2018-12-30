//
//  XYJCacheUtils.m
//  key
//
//  Created by MissYasiky on 2018/11/25.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJCacheUtils.h"
#import "NSString+XYJMess.h"

extern NSString *const XYJBankCardID;

@implementation XYJCacheUtils

+ (NSArray *)bankNameArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XYJDataConstant" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *array = dict[@"bankName"];
    return array;
}

+ (NSDictionary *)cacheOldReadPreprocess:(NSDictionary *)originDict {
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] initWithDictionary:originDict];
    for (NSString *key in [originDict allKeys]) {
        id value = originDict[key];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *revertString = [value xyj_revert];
            [muDict setObject:revertString forKey:key];
        }
    }
    return [muDict mutableCopy];
}

+ (NSDictionary *)cacheWritePreprocess:(NSDictionary *)originDict {
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] initWithDictionary:originDict];
    for (NSString *key in [originDict allKeys]) {
        if ([key isEqualToString:XYJBankCardID]) {
            continue;
        }
        id value = originDict[key];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *messString = [value xyj_mess];
            NSString *encodeString = [messString xyj_encode];
            [muDict setObject:encodeString forKey:key];
        }
    }
    return [muDict mutableCopy];
}

+ (NSDictionary *)cacheReadPreprocess:(NSDictionary *)originDict {
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] initWithDictionary:originDict];
    for (NSString *key in [originDict allKeys]) {
        if ([key isEqualToString:XYJBankCardID]) {
            continue;
        }
        id value = originDict[key];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *decodeString = [value xyj_decode];
            NSString *revertString = [decodeString xyj_revert];
            [muDict setObject:revertString forKey:key];
        }
    }
    return [muDict mutableCopy];
}

@end
