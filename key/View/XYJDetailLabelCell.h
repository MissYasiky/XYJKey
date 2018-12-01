//
//  XYJDetailLabelCell.h
//  key
//
//  Created by MissYasiky on 2018/12/1.
//  Copyright © 2018 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYJDetailLabelCell : UITableViewCell

/**
 @param type 设置cell的accessoryType，默认是 UITableViewCellAccessoryNone
 @param selectionStyle 设置cell的selectionStyle，默认是UITableViewCellSelectionStyleNone
 */
- (void)setAccessoryType:(UITableViewCellAccessoryType)type selectionStyle:(UITableViewCellSelectionStyle)selectionStyle;

- (void)setLeftLabelText:(NSString *)leftContent rightLabelText:(NSString *)rightContent;

+ (CGFloat)height;

@end
