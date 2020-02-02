//
//  XYJSimpleLabelCell.m
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJSimpleLabelCell.h"

static CGFloat const kCellHeight = 80.0;

@interface XYJSimpleLabelCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *seperatorView;

@end
@implementation XYJSimpleLabelCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.indicatorImageView];
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.seperatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = XYJScreenWidth();
    CGFloat height = kCellHeight;
    CGFloat xPadding = 25.0;
    self.iconImageView.frame = CGRectMake(xPadding, (height - 23) / 2.0, 23, 23);
    self.indicatorImageView.frame = CGRectMake(width - xPadding - 20, (height - 16) / 2.0, 20, 16);
    
    CGFloat originX = self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 10;
    CGFloat labelWidth = self.indicatorImageView.frame.origin.x - originX;
    self.label.frame = CGRectMake(originX, (height - 17) / 2.0, labelWidth, 17);
    self.seperatorView.frame = CGRectMake(xPadding, height - 0.5, width - xPadding - xPadding, 0.5);
}

#pragma mark - Getter & Setter

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIImageView *)indicatorImageView {
    if (_indicatorImageView == nil) {
        _indicatorImageView = [[UIImageView alloc] init];
        [_indicatorImageView setImage:[UIImage imageNamed:@"list_indicator_arrow"]];
    }
    return _indicatorImageView;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont fontWithName:XYJ_Regular_Font size:15];
        _label.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color];
    }
    return _label;
}

- (UIView *)seperatorView {
    if (_seperatorView == nil) {
        _seperatorView = [[UIView alloc] init];
        _seperatorView.backgroundColor = [XYJColorUtils colorWithHexString:XYJ_Line_Color];
    }
    return _seperatorView;
}

#pragma mark - Public

- (void)setCellIconImageName:(NSString *)imageName {
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];
}

- (void)setChecked:(BOOL)checked {
    self.indicatorImageView.hidden = NO;
    NSString *imageName = checked ? @"list_indicator_checked" : @"list_indicator_uncheck";
    [self.indicatorImageView setImage:[UIImage imageNamed:imageName]];
}

- (void)hiddenIndicator {
    self.indicatorImageView.hidden = YES;
}

- (void)setLabelText:(NSString *)text {
    self.label.text = text;
}

+ (CGFloat)height {
    return kCellHeight;
}

@end
