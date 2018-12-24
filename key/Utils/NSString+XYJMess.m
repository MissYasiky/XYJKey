//
//  NSString+XYJMess.m
//  key
//
//  Created by MissYasiky on 2018/12/17.
//  Copyright © 2018 netease. All rights reserved.
//

#import "NSString+XYJMess.h"

static NSDictionary *numberMessMap() {
    static NSDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{
                 @"0":@"5",
                 @"1":@"4",
                 @"2":@"8",
                 @"3":@"3",
                 @"4":@"9",
                 @"5":@"0",
                 @"6":@"1",
                 @"7":@"2",
                 @"8":@"6",
                 @"9":@"7"
                 };
    });
    return dict;
}

static NSDictionary *numberRevertMap() {
    static NSDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{
                 @"0":@"5",
                 @"1":@"6",
                 @"2":@"7",
                 @"3":@"3",
                 @"4":@"1",
                 @"5":@"0",
                 @"6":@"8",
                 @"7":@"9",
                 @"8":@"2",
                 @"9":@"4"
                 };
    });
    return dict;
}

@implementation NSString (XYJMess)

- (NSString *)xyjmess {
    if (self.length == 0) {
        return self;
    }
    NSMutableString *muString = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < self.length; i++) {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        BOOL isNumber = [character isSingleCharacterIsNumber];
        if (isNumber) {
            [muString appendString:numberMessMap()[character]];
        } else {
            [muString appendString:character];
        }
    }
    return [muString mutableCopy];
}

- (NSString *)xyjrevert {
    if (self.length == 0) {
        return self;
    }
    NSMutableString *muString = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < self.length; i++) {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        BOOL isNumber = [character isSingleCharacterIsNumber];
        if (isNumber) {
            [muString appendString:numberRevertMap()[character]];
        } else {
            [muString appendString:character];
        }
    }
    return [muString mutableCopy];
}

- (BOOL)isSingleCharacterIsNumber {
    if (self.length != 1) {
        return NO;
    }
    if ([self isEqualToString:@"0"]) {
        return YES;
    }
    NSInteger integ = [self integerValue];
    if (integ > 0 && integ <= 9) {
        return YES;
    }
    return NO;
}

@end
