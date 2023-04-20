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

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

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

- (BOOL)isPasswordCorrect:(NSString *)password {
    if (password.length != 4) {
        return NO;
    }
    NSString *timeString = [self.dateFormatter stringFromDate:[NSDate date]];
    NSInteger hour = [[timeString substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger min = [[timeString substringWithRange:NSMakeRange(2, 2)] integerValue];
    NSInteger passwordPartOne = [[password substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger passwordPartTwo = [[password substringWithRange:NSMakeRange(2, 2)] integerValue];
    if (hour + 12 == passwordPartOne && min + 4 == passwordPartTwo) {
        return YES;
    }
    return NO;
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

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"HHmm";
    }
    return _dateFormatter;
}

#pragma mark - Private

- (void)lockAgain {
    self.unlock = NO;
}

@end
