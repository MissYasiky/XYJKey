//
//  XYJCardModel+WCTTableCoding.h
//  key
//
//  Created by MissYasiky on 2020/12/4.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCardModel.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYJCardModel (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(createTime)
WCDB_PROPERTY(bankName)
WCDB_PROPERTY(accountNum)
WCDB_PROPERTY(validThru)
WCDB_PROPERTY(cvv2)
WCDB_PROPERTY(creditCard)
WCDB_PROPERTY(myOwn)
WCDB_PROPERTY(externDict)

@end

NS_ASSUME_NONNULL_END
