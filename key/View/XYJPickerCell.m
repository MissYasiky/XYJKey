//
//  XYJPickerCell.m
//  key
//
//  Created by MissYasiky on 2018/11/23.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJPickerCell.h"

static CGFloat kCellHeight = 42.0;
static CGFloat kRightPad = 30.0;

@interface XYJPickerCell ()

@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation XYJPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.textLabel.font = [UIFont systemFontOfSize:18];
        self.textLabel.textColor = XYJColor(0x696969, 1.0);
        
        [self.contentView addSubview:self.rightLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.rightLabel.frame = CGRectMake(120, (kCellHeight - 20)/2.0, XYJScreenWidth() - 120 - kRightPad, 20);
}

#pragma mark - Getter & Setter

- (UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:16];
        _rightLabel.textColor = XYJColor(0xa4a4a4, 1.0);
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

#pragma mark - Public

- (void)setLeftLabelText:(NSString *)leftContent rightLabelText:(NSString *)rightContent {
    if (leftContent != nil && leftContent.length != 0) {
        self.textLabel.text = leftContent;
    }
    if (rightContent != nil && rightContent.length != 0) {
        self.rightLabel.text = rightContent;
    }
}

@end
