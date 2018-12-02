//
//  XYJCacheUtils.h
//  key
//
//  Created by MissYasiky on 2018/11/25.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const XYJBankNameKey;
extern NSString * const XYJBankAccountKey;
extern NSString * const XYJBankCreditCardKey;
extern NSString * const XYJEBankPasswordKey;
extern NSString * const XYJBankQueryPasswordKey;
extern NSString * const XYJBankWithdrawalPasswordKey;
extern NSString * const XYJBankRemarkKey;

extern NSString * const XYJAddNewBankCardNotification;
extern NSString * const XYJEditBankCardNotification;

@interface XYJCacheUtils : NSObject

+ (NSArray *)bankNameArray;

+ (BOOL)writeBankCardToCache:(NSDictionary *)dict;

+ (NSArray *)bankCardFromCache;

+ (NSDictionary *)bankCardAtIndex:(NSInteger)index;

+ (BOOL)deleteBankCardAtIndex:(NSInteger)index;

+ (BOOL)replaceBandCard:(NSDictionary *)info atIndex:(NSInteger)index;

@end
