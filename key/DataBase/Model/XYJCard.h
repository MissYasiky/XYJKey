//
//  XYJCard.h
//  key
//
//  Created by MissYasiky on 2020/11/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 银行卡数据模型
@interface XYJCard : NSObject

/// 数据创建时间，数据库关键字段，不可为空
@property (nonatomic, assign) NSTimeInterval createTime;

/// 是否是信用卡，默认为 0，0-借记卡/1-信用卡
@property (nonatomic, assign) int isCreditCard;

/// 是否本人的卡，默认为 1，0-别人的卡，1-自己的卡
@property (nonatomic, assign) int isOwn;

/// 银行名称，不可为空
@property (nonatomic, copy) NSString *bankName;

/// 银行卡号，不可为空，应为不带符号的数字字符串
@property (nonatomic, copy) NSString *accountNum;

/// 信用卡有效期，不可为空，应为不带符号的4位数字字符串
@property (nonatomic, copy) NSString * _Nullable validThru;

/// 信用卡安全码，不可为空，应为不带符号的3位数字字符串
@property (nonatomic, copy) NSString * _Nullable cvv2;

/// 自定义信息，用于各种其他信息补充
@property (nonatomic, strong) NSDictionary * _Nullable externDict;

#pragma mark - 字段格式检查

/// 检查字段 accountNum 是否符号要求
+ (BOOL)isValidAccountNum:(NSString *)accountNum;

/// 检查字段 validThru 是否符号要求
+ (BOOL)isValidThruValid:(NSString *)validThru;

/// 检查字段 cvv2 是否符号要求
+ (BOOL)isValidCvv2:(NSString *)cvv2;

/// 检查不可为空的字段是否都非空
- (BOOL)isValid;

#pragma mark - View Model

/// 根据字段 isCreditCard 返回 “信用卡”/“借记卡”
- (NSString *)cardTypeString;

/// 根据字段 isOwn 返回写死的卡片持有者名字
- (NSString *)cardOwnerString;

/// 根据字段 validThru 返回格式为 MM/yy 的字符串
- (NSString *)formatValidThruString;

@end

NS_ASSUME_NONNULL_END
