//
//  XYJHomeListCell.h
//  key
//
//  Created by MissYasiky on 2020/2/1.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYJHomeListCell : UITableViewCell

- (void)setCellStyleForAccount:(BOOL)account;

- (void)setTextForLineOne:(NSString *)lineOneText lineTwo:(NSString *)lineTwoText lineThree:(NSString *)lineThreeText;

- (void)setTextForLineOne:(NSString *)lineOneText lineTwo:(NSString *)lineTwoText lineThree:(NSString *)lineThreeText other:(BOOL)other;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
