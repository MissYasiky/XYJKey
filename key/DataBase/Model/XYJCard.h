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

/// 数据创建时间，数据库关键字段
@property (nonatomic, assign) NSTimeInterval createTime;

/// 是否是信用卡，默认为 0
@property (nonatomic, assign) int isCreditCard;

/// 是否本人的卡，默认为 1
@property (nonatomic, assign) int isOwn;

/// 银行名称
@property (nonatomic, copy) NSString *bankName;

/// 银行卡号
@property (nonatomic, copy) NSString *accountNum;

/// 信用卡有效期
@property (nonatomic, copy) NSString * _Nullable validThru;

/// 信用卡安全码，三位数字
@property (nonatomic, copy) NSString * _Nullable cvv2;

/// 自定义信息
@property (nonatomic, strong) NSDictionary * _Nullable externDict;

@end

NS_ASSUME_NONNULL_END
