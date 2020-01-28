//
//  XYJSecrecyManager.h
//  key
//
//  Created by MissYasiky on 2020/1/28.
//  Copyright © 2020 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XYJ_PassWord_Necessary 1

NS_ASSUME_NONNULL_BEGIN

@interface XYJSecrecyManager : NSObject

@property (nonatomic, assign, readonly) BOOL unlock;

+ (instancetype)sharedManager;

- (void)unlockForSeconds;

@end

NS_ASSUME_NONNULL_END
