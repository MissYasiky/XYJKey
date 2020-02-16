//
//  XYJDetailLabelCell.h
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2018 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYJDetailLabelCellStyle) {
    XYJDetailLabelCellStyleLabel = 0, // 默认 style 纯文本展示
    XYJDetailLabelCellStyleTextField,
    XYJDetailLabelCellStylePicker
};

NS_ASSUME_NONNULL_BEGIN

@interface XYJDetailLabelCell : UITableViewCell

@property (nonatomic, assign) XYJDetailLabelCellStyle style;

/**
 已废弃 - 旧页面在使用
 @param type 设置cell的accessoryType，默认是 UITableViewCellAccessoryNone
 @param selectionStyle 设置cell的selectionStyle，默认是UITableViewCellSelectionStyleNone
 */
- (void)setAccessoryType:(UITableViewCellAccessoryType)type selectionStyle:(UITableViewCellSelectionStyle)selectionStyle;

/// 已废弃 - 旧页面在使用
- (void)setLeftLabelText:(NSString *)leftContent rightLabelText:(NSString *)rightContent;

/// 调用此方法，style 为 XYJDetailLabelCellStyleLabel
- (void)setTextForLineOne:(NSString *)lineOneText lineTwo:(NSString *)lineTwoText;

/// 调用此方法，style 为 XYJDetailLabelCellStyleTextField
- (void)setTextForTitle:(NSString *)text content:(NSString  * _Nullable)content placeHolder:(NSString *)placeHolder;

/// 调用此方法，style 为 XYJDetailLabelCellStylePicker
- (void)setTextForTitle:(NSString *)text picker:(NSString *)pickerText;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
