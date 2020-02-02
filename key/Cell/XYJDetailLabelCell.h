//
//  XYJDetailLabelCell.h
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2018 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYJDetailLabelCellStyle) {
    XYJDetailLabelCellStyleLabel = 0,
    XYJDetailLabelCellStyleTextField,
    XYJDetailLabelCellStylePicker
};

@interface XYJDetailLabelCell : UITableViewCell

@property (nonatomic, assign) XYJDetailLabelCellStyle style;

/**
 @param type 设置cell的accessoryType，默认是 UITableViewCellAccessoryNone
 @param selectionStyle 设置cell的selectionStyle，默认是UITableViewCellSelectionStyleNone
 */
- (void)setAccessoryType:(UITableViewCellAccessoryType)type selectionStyle:(UITableViewCellSelectionStyle)selectionStyle;

- (void)setLeftLabelText:(NSString *)leftContent rightLabelText:(NSString *)rightContent;

- (void)setTextForLineOne:(NSString *)lineOneText lineTwo:(NSString *)lineTwoText;

+ (CGFloat)height;

@end
