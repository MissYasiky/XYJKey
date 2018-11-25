//
//  XYJSwitchCell.m
//  key
//
//  Created by MissYasiky on 2018/11/23.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJSwitchCell.h"

static CGFloat kCellHeight = 42.0;
static CGFloat kRightPad = 15.0;

@interface XYJSwitchCell ()


@end

@implementation XYJSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = [UIFont systemFontOfSize:18];
        self.textLabel.textColor = XYJColor(0x696969, 1.0);
        
        [self.contentView addSubview:self.aSwitch];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint point = CGPointZero;
    CGSize size = self.aSwitch.frame.size;
    point.x = XYJScreenWidth() - size.width - kRightPad;
    point.y = (kCellHeight - size.height) / 2.;
    self.aSwitch.frame = CGRectMake(point.x, point.y, size.width, size.height);
}

#pragma mark - Getter & Setter

- (UISwitch *)aSwitch {
    if (_aSwitch == nil) {
        _aSwitch = [[UISwitch alloc] init];
        _aSwitch.on = NO;
    }
    return _aSwitch;
}

#pragma mark - Public

- (void)setLeftLabelText:(NSString *)leftContent switchOn:(BOOL)on {
    if (leftContent != nil && leftContent.length != 0) {
        self.textLabel.text = leftContent;
    }
    self.aSwitch.on = on;
}

@end
