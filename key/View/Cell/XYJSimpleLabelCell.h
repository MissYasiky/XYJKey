//
//  XYJSimpleLabelCell.h
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYJSimpleLabelCellStyle) {
    XYJSimpleLabelCellDefault = 0, // 默认 style 带小箭头
    XYJSimpleLabelCellCheck, // 对勾模式
    XYJSimpleLabelCellOnlyLabel // 无小箭头或对勾，只有展示文本
};

NS_ASSUME_NONNULL_BEGIN

@interface XYJSimpleLabelCell : UITableViewCell

@property (nonatomic, assign) XYJSimpleLabelCellStyle style;

- (void)setCellIconImageName:(NSString *)imageName;

- (void)setLabelText:(NSString *)text;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
