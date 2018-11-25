//
//  XYJSwitchCell.h
//  key
//
//  Created by MissYasiky on 2018/11/23.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYJSwitchCell : UITableViewCell

@property (nonatomic, strong) UISwitch *aSwitch;

- (void)setLeftLabelText:(NSString *)leftContent switchOn:(BOOL)on;

@end
