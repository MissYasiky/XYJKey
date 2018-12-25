//
//  XYJCacheUtils.m
//  key
//
//  Created by MissYasiky on 2018/11/25.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJCacheUtils.h"
#import "NSString+XYJMess.h"

@implementation XYJCacheUtils

+ (NSArray *)bankNameArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XYJDataConstant" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *array = dict[@"bankName"];
    return array;
}

+ (NSDictionary *)messDataBeforeCache:(NSDictionary *)originDict {
    NSMutableDictionary *muDict = [NSMutableDictionary new];
    for (NSString *key in [originDict allKeys]) {
        id value = originDict[key];
        if ([value isKindOfClass:[NSString class]]) {
            [muDict setObject:[value xyj_mess] forKey:key];
        } else {
            [muDict setObject:value forKey:key];
        }
    }
    return [muDict mutableCopy];
}

+ (NSDictionary *)revertMessedData:(NSDictionary *)originDict {
    NSMutableDictionary *muDict = [NSMutableDictionary new];
    for (NSString *key in [originDict allKeys]) {
        id value = originDict[key];
        if ([value isKindOfClass:[NSString class]]) {
            [muDict setObject:[value xyj_revert] forKey:key];
        } else {
            [muDict setObject:value forKey:key];
        }
    }
    return [muDict mutableCopy];
}

+ (NSString *)realCacheString:(NSString *)userString {
    return [userString xyj_mess];
}

@end
