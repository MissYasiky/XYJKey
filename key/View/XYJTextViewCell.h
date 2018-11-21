//
//  XYJTextViewCell.h
//  key
//
//  Created by MissYasiky on 2018/11/21.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYJTextViewCell : UITableViewCell

- (void)setTextViewContent:(NSString *)content delegate:(id<UITextViewDelegate>)delegate ;

+ (CGFloat)height;

@end
