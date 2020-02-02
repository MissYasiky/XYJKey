//
//  XYJSimpleLabelCell.h
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYJSimpleLabelCell : UITableViewCell

- (void)setCellIconImageName:(NSString *)imageName;

- (void)setChecked:(BOOL)checked;

- (void)hiddenIndicator;

- (void)setLabelText:(NSString *)text;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
