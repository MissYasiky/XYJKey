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

static int const upperCaseAASCII = 65;
static int const upperCaseZASCII = 90;
static int const lowerCaseAASCII = 97;
static int const lowerCaseZASCII = 122;
static int const messASCIIGap = -4;

static int const messedUpperCaseAASCII = upperCaseAASCII + messASCIIGap;
static int const messedUpperCaseZASCII = upperCaseZASCII + messASCIIGap;
static int const messedLowerCaseAASCII = lowerCaseAASCII + messASCIIGap;
static int const messedLowerCaseZASCII = lowerCaseZASCII + messASCIIGap;
static int const revertASCIIGap = -messASCIIGap;

@implementation NSString (XYJMess)

- (NSString *)xyj_mess {
    if (self.length == 0) {
        return self;
    }
    NSMutableString *muString = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < self.length; i++) {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        BOOL isNumber = [character isSingleCharacterIsNumber];
        if (isNumber) {
            [muString appendString:numberMessMap()[character]];
        } else if ([character isSingleCharacter]) {
            int asciiCode = [character characterAtIndex:0];
            NSString *newCharacter =[NSString stringWithFormat:@"%c",asciiCode + messASCIIGap];
            [muString appendString:newCharacter];
        } else {
            [muString appendString:character];
        }
    }
    return [muString mutableCopy];
}

- (NSString *)xyj_revert {
    if (self.length == 0) {
        return self;
    }
    NSMutableString *muString = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < self.length; i++) {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        BOOL isNumber = [character isSingleCharacterIsNumber];
        if (isNumber) {
            [muString appendString:numberRevertMap()[character]];
        } else if ([character isSingleRevertCharacter]) {
            int asciiCode = [character characterAtIndex:0];
            NSString *newCharacter =[NSString stringWithFormat:@"%c",asciiCode + revertASCIIGap];
            [muString appendString:newCharacter];
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

- (BOOL)isSingleCharacter {
    if (self.length != 1) {
        return NO;
    }
    int asciiCode = [self characterAtIndex:0];
    return ((asciiCode >= upperCaseAASCII && asciiCode <= upperCaseZASCII) || (asciiCode >= lowerCaseAASCII && asciiCode <= lowerCaseZASCII));
}

- (BOOL)isSingleRevertCharacter {
    if (self.length != 1) {
        return NO;
    }
    int asciiCode = [self characterAtIndex:0];
    return ((asciiCode >= messedUpperCaseAASCII && asciiCode <= messedUpperCaseZASCII) || (asciiCode >= messedLowerCaseAASCII && asciiCode <= messedLowerCaseZASCII));
}

@end
