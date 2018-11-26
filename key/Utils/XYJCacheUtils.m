//
//  XYJCacheUtils.m
//  key
//
//  Created by MissYasiky on 2018/11/25.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJCacheUtils.h"

static NSString *kBandCardFile = @"BCCache";

@implementation XYJCacheUtils

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
    NSArray *array = [NSJSONSerialization JSONObjectWithData:cacheData
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];
    return array;
}
@end
