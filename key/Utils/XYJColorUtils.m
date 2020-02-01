//
//  XYJColorUtils.m
//  key
//
//  Created by MissYasiky on 2020/2/1.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJColorUtils.h"

UIColor *XYJColor(NSInteger hexValue) {
    return XYJColorWithAlpha(hexValue, 1);
}

UIColor *XYJColorWithAlpha(NSInteger hexValue, CGFloat alpha) {
    NSInteger red = hexValue & 0xff0000 >> 16;
    NSInteger green = hexValue & 0x00ff00 >> 8;
    NSInteger blue = hexValue & 0x0000ff;
    return [UIColor colorWithRed:red/255.0
                           green:green/255.0
                            blue:blue/255.0
                           alpha:MAX(MIN(alpha, 1), 0)];
}

@implementation XYJColorUtils

@end
