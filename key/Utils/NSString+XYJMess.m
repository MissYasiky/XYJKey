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
static int const lowerCaseZASCII = 122;
static int const messASCIIGap = -4;
static int const revertASCIIGap = -messASCIIGap;

@implementation NSString (XYJMess)

- (NSString *)xyj_mess {
    if (self.length == 0) {
        return self;
    }
    NSMutableString *muString = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < self.length; i++) {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        BOOL isNumber = [character xyj_isSingleNumber];
        if (isNumber) {
            [muString appendString:numberMessMap()[character]];
        } else if ([character isSingleCharacter]) {
            NSString *newCharacter = [character messCharacter:messASCIIGap];
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
        BOOL isNumber = [character xyj_isSingleNumber];
        if (isNumber) {
            [muString appendString:numberRevertMap()[character]];
        } else if ([character isSingleCharacter]) {
            NSString *newCharacter = [character messCharacter:revertASCIIGap];
            [muString appendString:newCharacter];
        } else {
            [muString appendString:character];
        }
    }
    return [muString mutableCopy];
}

- (NSString *)xyj_encode {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *codeStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return codeStr ?: @"";
}

- (NSString *)xyj_decode {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *codeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return codeStr ?: @"";
}

// 是否为一位数的数字字符串
- (BOOL)xyj_isSingleNumber {
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

- (BOOL)xyj_isPureNumberWithoutSymbol {
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    return string.length == 0;
}

// 还包括 ASCII 码处于大小写字母中间的几个符号 [ \ ] ^ _ '
- (BOOL)isSingleCharacter {
    if (self.length != 1) {
        return NO;
    }
    int asciiCode = [self characterAtIndex:0];
    return (asciiCode >= upperCaseAASCII && asciiCode <= lowerCaseZASCII);
}

- (NSString *)messCharacter:(int)messPad {
    if (self.length != 1) {
        return self;
    }
    if ([self isSingleCharacter] == NO) {
        return self;
    }
    int asciiCode = [self characterAtIndex:0];
    int newAsciiCode = asciiCode + messPad;
    if (asciiCode + messPad < upperCaseAASCII) {
        newAsciiCode = lowerCaseZASCII - upperCaseAASCII + (asciiCode + messPad) + 1;
    } else if (asciiCode + messPad > lowerCaseZASCII) {
        newAsciiCode = upperCaseAASCII + (asciiCode + messPad) - lowerCaseZASCII - 1;
    }
    NSString *newCharacter =[NSString stringWithFormat:@"%c",newAsciiCode];
    return newCharacter;
}

@end
