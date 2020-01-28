//
//  XYJSecrecyManager.m
//  key
//
//  Created by MissYasiky on 2020/1/28.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJSecrecyManager.h"

@interface XYJSecrecyManager ()

@property (nonatomic, assign) BOOL unlock;

@property (nonatomic, assign) NSTimeInterval unlockTimeInterval;

@end

@implementation XYJSecrecyManager

#pragma mark - Public

+ (instancetype)sharedManager {
    static XYJSecrecyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XYJSecrecyManager alloc] init];
    });
    return manager;
}

- (void)unlockForSeconds {
    self.unlock = YES;
    self.unlockTimeInterval = [NSDate date].timeIntervalSince1970;
}

#pragma mark - Getter & Setter

- (BOOL)unlock {
    NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970;
    if (timeInterval - self.unlockTimeInterval >= 60) {
        [self lockAgain];
        return NO;
    } else {
        return _unlock;
    }
}

#pragma mark - Private

- (void)lockAgain {
    self.unlock = NO;
}

@end
