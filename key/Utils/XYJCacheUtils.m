//
//  XYJCacheUtils.m
//  key
//
//  Created by MissYasiky on 2018/11/25.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJCacheUtils.h"

@implementation XYJCacheUtils

+ (NSArray *)bankNameArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XYJDataConstant" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *array = dict[@"bankName"];
    return array;
}

@end
