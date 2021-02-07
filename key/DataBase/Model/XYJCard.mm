//
//  XYJCard.m
//  key
//
//  Created by MissYasiky on 2020/11/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCard.h"
#import <WCDB/WCDB.h>

@implementation XYJCard

WCDB_IMPLEMENTATION(XYJCard)

WCDB_SYNTHESIZE(XYJCard, createTime)
WCDB_SYNTHESIZE(XYJCard, isCreditCard)
WCDB_SYNTHESIZE(XYJCard, isOwn)
WCDB_SYNTHESIZE(XYJCard, bankName)
WCDB_SYNTHESIZE(XYJCard, accountNum)
WCDB_SYNTHESIZE(XYJCard, validThru)
WCDB_SYNTHESIZE(XYJCard, cvv2)
WCDB_SYNTHESIZE(XYJCard, externDict)

WCDB_PRIMARY(XYJCard, createTime)

- (instancetype)init {
    self = [super init];
    if (self) {
        _isOwn = 1;
    }
    return self;
}

- (NSString *)debugDescription {
    return nil;
}

@end
