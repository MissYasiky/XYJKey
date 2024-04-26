//
//  XYJAccount+WCTTableCoding.h
//  key
//
//  Created by MissYasiky on 2021/03/05.
//  Copyright © 2021 netease. All rights reserved.
//

#import "XYJAccount.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYJAccount (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(createTime)
WCDB_PROPERTY(accountName)
WCDB_PROPERTY(externDict)
WCDB_PROPERTY(externString)


@end

NS_ASSUME_NONNULL_END
