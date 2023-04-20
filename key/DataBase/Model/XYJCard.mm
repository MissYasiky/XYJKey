//
//  XYJCard.m
//  key
//
//  Created by MissYasiky on 2020/11/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCard.h"
#import "NSString+Util.h"
#import <WCDB/WCDB.h>

@implementation XYJCard

// 数据库类名
WCDB_IMPLEMENTATION(XYJCard)

// 数据库字段
WCDB_SYNTHESIZE(XYJCard, createTime)
WCDB_SYNTHESIZE(XYJCard, isCreditCard)
WCDB_SYNTHESIZE(XYJCard, isOwn)
WCDB_SYNTHESIZE(XYJCard, bankName)
WCDB_SYNTHESIZE(XYJCard, accountNum)
WCDB_SYNTHESIZE(XYJCard, validThru)
WCDB_SYNTHESIZE(XYJCard, cvv2)
WCDB_SYNTHESIZE(XYJCard, externDict)

// 数据库关键字
WCDB_PRIMARY(XYJCard, createTime)

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _isOwn = 1;
        _createTime = floor([[NSDate date] timeIntervalSince1970] * 1000);
    }
    return self;
}

#pragma mark - Setter
/// 通过重写 setter 方法对字段的格式进行检查，不符合格式无法成功赋值

- (void)setIsCreditCard:(int)isCreditCard {
    if (isCreditCard <= 0) {
        _isCreditCard = 0;
    } else {
        _isCreditCard = 1;
    }
}

- (void)setIsOwn:(int)isOwn {
    if (isOwn <= 0) {
        _isOwn = 0;
    } else {
        _isOwn = 1;
    }
}

- (void)setAccountNum:(NSString *)accountNum {
    BOOL valid = [XYJCard isValidAccountNum:accountNum];
    if (valid) {
        _accountNum = accountNum;
    } else {
        _accountNum = nil;
    }
}

- (void)setValidThru:(NSString *)validThru {
    BOOL valid = [XYJCard isValidThruValid:validThru];
    if (valid) {
        if (validThru.length > 4) { // 超过4位截取前4位
            validThru = [validThru substringToIndex:4];
        }
        _validThru = validThru;
    } else {
        _validThru = nil;
    }
}

- (void)setCvv2:(NSString *)cvv2 {
    BOOL valid = [XYJCard isValidCvv2:cvv2];
    if (valid) {
        if (cvv2.length > 3) { // 超过3位截取前3位
            cvv2 = [cvv2 substringToIndex:3];
        }
        _cvv2 = cvv2;
    } else {
        _cvv2 = nil;
    }
}

#pragma mark - 字段格式检查

/// 检查字段 accountNum 是否符号要求
+ (BOOL)isValidAccountNum:(NSString *)accountNum {
    BOOL pureNumber = [accountNum xyj_isPureNumber];
    if (!pureNumber || [accountNum integerValue] <= 0) { // 该字段应为不带符号的数字字符串
        return NO;
    }
    return YES;
}

/// 检查字段 validThru 是否符号要求
+ (BOOL)isValidThruValid:(NSString *)validThru {
    BOOL pureNumber = [validThru xyj_isPureNumber];
    if (!pureNumber || [validThru integerValue] <= 0 || validThru.length < 4) { // 该字段应为不带符号的4位数字字符串
        return NO;
    }
    if (validThru.length > 4) { // 超过4位截取前4位
        validThru = [validThru substringToIndex:4];
    }
    NSInteger month = [[validThru substringToIndex:2] integerValue];
    NSInteger year = [[validThru substringFromIndex:2] integerValue];
    if (month > 12 || month <= 0) { // 月份必须在[1,12]区间中
        return NO;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy";
    NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    if (year < currentYear) { // 年份必须不小于当前年份
        return NO;
    }
    return YES;
}

/// 检查字段 cvv2 是否符号要求
+ (BOOL)isValidCvv2:(NSString *)cvv2 {
    BOOL pureNumber = [cvv2 xyj_isPureNumber];
    if (!pureNumber || [cvv2 integerValue] <= 0 || cvv2.length < 3) {// 该字段应为不带符号的3位数字字符串
        return NO;
    }
    return YES;
}

#pragma mark - View Model

/// 根据字段 isCreditCard 返回 “信用卡”/“借记卡”
- (NSString *)cardTypeString {
    NSString *cardType = self.isCreditCard > 0 ? @"信用卡" : @"借记卡";
    return cardType;
}

/// 根据字段 isOwn 返回写死的卡片持有者名字
- (NSString *)cardOwnerString {
    NSString *cardOwner = self.isOwn > 0 ? @"XIE YUN JIA" : @"OTHER";
    return cardOwner;
}

/// 根据字段 validThru 返回格式为 MM/yy 的字符串
- (NSString *)formatValidThruString {
    if (!self.validThru || self.validThru.length == 0) {
        return @"null";
    } else if (self.validThru.length <= 2) {
        return self.validThru;
    } else {
        NSString *month = [self.validThru substringToIndex:2];
        NSString *year = [self.validThru substringFromIndex:2];
        return [NSString stringWithFormat:@"%@/%@", month, year];
    }
}

/// 根据字段 accountNum 返回末四位字符串，不足四位返回全部字符串
- (NSString *)lastFourAccountNumber {
    if (!self.accountNum || self.accountNum.length == 0) {
        return @"null";
    } else if (self.accountNum.length < 4) {
        return self.accountNum;
    } else {
        return [self.accountNum substringFromIndex:self.accountNum.length - 4];
    }
}

#pragma mark - description

- (NSString *)description {
    return [NSString stringWithFormat:@"%@%@末四位%@", _bankName, [self cardTypeString], [self lastFourAccountNumber]];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p, \"%@的%@%@,末四位为%@\">", [self class], self, [self cardOwnerString], _bankName, [self cardTypeString], [self lastFourAccountNumber]];
}

@end
