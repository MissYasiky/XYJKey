//
//  XYJDailyTools.h
//  key
//
//  Created by MissYasiky on 2018/11/15.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XYJ_Bold_Font @"PingFangSC-Semibold"

#define XYJ_Regular_Font @"PingFangSC-Regular"

#define XYJ_ScreenWidth ([UIScreen mainScreen].bounds.size.width)

#define XYJ_ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define XYJ_StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)

#define XYJ_NavigationBarHeight (self.navigationController.navigationBar.frame.size.height)

@interface XYJDailyTools : NSObject

+ (NSString *)jsonStringWithJSONObject:(id)jsonObject;

@end
