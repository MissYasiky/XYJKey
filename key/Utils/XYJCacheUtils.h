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

+ (NSDictionary *)messDataBeforeCache:(NSDictionary *)originDict;

+ (NSDictionary *)revertMessedData:(NSDictionary *)originDict;

+ (NSString *)realCacheString:(NSString *)userString;

@end
