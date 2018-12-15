//
//  XYJTextFieldCell.h
//  key
//
//  Created by MissYasiky on 2018/11/21.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYJTextFieldCell : UITableViewCell

- (void)setTextFieldDelegate:(id<UITextFieldDelegate>)delegate;

- (void)setTextFieldTag:(NSInteger)tag
            placeholder:(NSString *)text
           keyboardTyep:(UIKeyboardType)type;

- (void)setLeftLabelText:(NSString *)leftContent textFieldContent:(NSString *)rightContent;

+ (CGFloat)height;

@end
