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

@interface XYJBankCardDao : NSObject

+ (instancetype)sharedDao;

- (void)closeDataBase;

@end
