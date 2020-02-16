//
//  XYJCustomKeyCell.h
//  key
//
//  Created by MissYasiky on 2020/2/16.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYJCustomKeyCellStyle) {
    XYJCustomKeyCellStyleKeyValue = 0, // 默认 style，key-value输入框模式
    XYJCustomKeyCellStyleAddKey
};

NS_ASSUME_NONNULL_BEGIN

@interface XYJCustomKeyCell : UITableViewCell

@property (nonatomic, assign) XYJCustomKeyCellStyle style;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
