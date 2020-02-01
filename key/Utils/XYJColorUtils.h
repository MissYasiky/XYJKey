//
//  XYJColorUtils.h
//  key
//
//  Created by MissYasiky on 2020/2/1.
//  Copyright © 2020 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define XYJ_Text_Color (0x343437)

#define XYJ_Text_Sub_Color (0x99999B)

#define XYJ_Line_Color (0xc1c2c2)

#define XYJ_Theme_Blue_Color (0x5392dc)

#define XYJ_Theme_Red_Color (0xdd5757)

extern UIColor *XYJColor(NSInteger hexValue);

extern UIColor *XYJColorWithAlpha(NSInteger hexValue, CGFloat alpha);

@interface XYJColorUtils : NSObject

@end

NS_ASSUME_NONNULL_END
