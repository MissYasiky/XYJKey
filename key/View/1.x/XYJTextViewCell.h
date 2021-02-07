//
//  XYJTextViewCell.h
//  key
//
//  Created by MissYasiky on 2018/11/21.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYJTextViewCell : UITableViewCell

@property (nonatomic, strong) UITextView *textView;

- (void)setTextViewContent:(NSString *)content;

+ (CGFloat)height;

@end
