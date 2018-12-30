//
//  XYJCacheUtils.h
//  key
//
//  Created by MissYasiky on 2018/11/25.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYJCacheUtils : NSObject

+ (NSArray *)bankNameArray;

+ (NSDictionary *)cacheOldReadPreprocess:(NSDictionary *)originDict;

+ (NSDictionary *)cacheWritePreprocess:(NSDictionary *)originDict;

+ (NSDictionary *)cacheReadPreprocess:(NSDictionary *)originDict;


@end
