//
//  XYJDailyTools.m
//  key
//
//  Created by MissYasiky on 2018/11/15.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJDailyTools.h"

@implementation XYJDailyTools

+ (NSString *)jsonStringWithJSONObject:(id)jsonObject {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
    NSMutableString *mutStr = nil;
    if (jsonData) {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        mutStr = [NSMutableString stringWithString:jsonString];
    }
    if (mutStr) {
        //去掉字符串中的空格
        NSRange range = {0, mutStr.length};
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        //去掉字符串中的换行符
        NSRange range2 = {0, mutStr.length};
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        return [mutStr copy];
    } else {
        return nil;
    }
}

@end
