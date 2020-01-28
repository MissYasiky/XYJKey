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

@property (nonatomic, strong) NSTimer *timer;

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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(lockAgain) userInfo:nil repeats:NO];
}

#pragma mark - Private

- (void)lockAgain {
    self.unlock = NO;
    [self.timer invalidate];
    self.timer = nil;
}

@end
