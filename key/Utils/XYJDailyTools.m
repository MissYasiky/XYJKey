//
//  XYJDailyTools.m
//  key
//
//  Created by MissYasiky on 2018/11/15.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJDailyTools.h"

UIColor *XYJColor(NSInteger hexValue, CGFloat alpha) {
    NSInteger red = hexValue & 0xff0000 >> 16;
    NSInteger green = hexValue & 0x00ff00 >> 8;
    NSInteger blue = hexValue & 0x0000ff;
    return [UIColor colorWithRed:red/255.0
                           green:green/255.0
                            blue:blue/255.0
                           alpha:MAX(MIN(alpha, 1), 0)];
}

CGFloat XYJScreenWidth () {
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat XYJScreenHeight () {
    return [UIScreen mainScreen].bounds.size.height;
}
@implementation XYJDailyTools

@end
