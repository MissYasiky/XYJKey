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

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha {
    if (!hexString || hexString.length < 6) {
        return [UIColor whiteColor];
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ([hexString rangeOfString:@"#"].location == 0) {
        [scanner setScanLocation:1]; // bypass '#' character
    }
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

@end
