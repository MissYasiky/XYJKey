//
//  XYJDetailLabelCell.h
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2018 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYJDetailLabelCellStyle) {
    XYJDetailLabelCellStyleLabel = 0, // 纯文本展示
    XYJDetailLabelCellStyleTextField, // 带输入框
};

typedef NS_ENUM(NSInteger, XYJDetailLabelCellTextFieldStyle) {
    XYJDetailLabelCellTextFieldStyleChinese = 0, // 中文键盘
    XYJDetailLabelCellTextFieldStyleNumber, // 银行卡类型
    XYJDetailLabelCellTextFieldStyleDate, // 日期类型
    XYJDetailLabelCellTextFieldStyleCVV // 三位安全码类型
};

NS_ASSUME_NONNULL_BEGIN

@interface XYJDetailLabelCell : UITableViewCell

@property (nonatomic, assign) XYJDetailLabelCellStyle style;

/// 输入框类型， style 为 XYJDetailLabelCellStyleTextField 时起效
@property (nonatomic, assign) XYJDetailLabelCellTextFieldStyle textFieldStyle;

@property (nonatomic, strong) NSString *enterContent;

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

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
