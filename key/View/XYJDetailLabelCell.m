//
//  XYJDetailLabelCell.m
//  key
//
//  Created by MissYasiky on 2018/12/1.
//  Copyright © 2018 netease. All rights reserved.
//

#import "XYJDetailLabelCell.h"

static CGFloat kCellHeight = 42.0;

@interface XYJDetailLabelCell ()

@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation XYJDetailLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = [UIFont systemFontOfSize:18];
        self.textLabel.textColor = XYJColor(0x696969, 1.0);
        
        [self.contentView addSubview:self.rightLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat rightPad = (self.accessoryType == UITableViewCellAccessoryNone) ? 15.0 : 30.0;
    self.rightLabel.frame = CGRectMake(120, (kCellHeight - 20)/2.0, XYJScreenWidth() - 120 - rightPad, 20);
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

- (void)setAccessoryType:(UITableViewCellAccessoryType)type selectionStyle:(UITableViewCellSelectionStyle)selectionStyle {
    self.accessoryType = type;
    self.selectionStyle = selectionStyle;
    [self layoutIfNeeded];
}

- (void)setLeftLabelText:(NSString *)leftContent rightLabelText:(NSString *)rightContent {
    if (leftContent != nil && leftContent.length != 0) {
        self.textLabel.text = leftContent;
    }
    if (rightContent != nil && rightContent.length != 0) {
        self.rightLabel.text = rightContent;
    }
}

+ (CGFloat)height {
    return kCellHeight;
}

@end
