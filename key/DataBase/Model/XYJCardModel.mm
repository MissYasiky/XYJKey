//
//  XYJCardModel.m
//  key
//
//  Created by MissYasiky on 2020/11/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCardModel.h"
#import <WCDB/WCDB.h>

@implementation XYJCardModel

WCDB_IMPLEMENTATION(XYJCardModel)

WCDB_SYNTHESIZE(XYJCardModel, createTime)
WCDB_SYNTHESIZE(XYJCardModel, isCreditCard)
WCDB_SYNTHESIZE(XYJCardModel, isOwn)
WCDB_SYNTHESIZE(XYJCardModel, bankName)
WCDB_SYNTHESIZE(XYJCardModel, accountNum)
WCDB_SYNTHESIZE(XYJCardModel, validThru)
WCDB_SYNTHESIZE(XYJCardModel, cvv2)
WCDB_SYNTHESIZE(XYJCardModel, externDict)

WCDB_PRIMARY(XYJCardModel, createTime)

- (instancetype)init {
    self = [super init];
    if (self) {
        _isOwn = 1;
    }
    return self;
}

@end
