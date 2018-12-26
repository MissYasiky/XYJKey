//
//  XYJBankCardDao.h
//  key
//
//  Created by MissYasiky on 2018/12/10.
//  Copyright © 2018 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const XYJBankCardID;
extern NSString *const XYJBankName;
extern NSString *const XYJBankCreditCard;
extern NSString *const XYJBankECardPassword;
extern NSString *const XYJBankQueryPassword;
extern NSString *const XYJBankWithdrawalPassword;
extern NSString *const XYJBankRemark;
extern NSString *const XYJBankCreateTime;

extern NSString *const XYJAddNewBankCardNotification;
extern NSString *const XYJEditBankCardNotification;

@interface XYJBankCardDao : NSObject

+ (instancetype)sharedDao;

- (void)closeDataBase;

- (void)insertData:(NSDictionary *)aDict completionBlock:(void(^)(BOOL success))block;

- (void)getDataWithCompletionBlock:(void (^)(NSArray <NSDictionary *> *datas))block;

- (void)getDataWithLimit:(NSUInteger)limit completionBlock:(void (^)(NSArray <NSDictionary *> *datas))block;

- (void)deleteDataWithId:(NSString *)dataId completionBlock:(void(^)(BOOL success))block;

- (void)updateData:(NSDictionary *)aDict completionBlock:(void(^)(BOOL success))block;

@end
