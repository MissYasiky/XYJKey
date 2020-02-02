//
//  XYJDetailLabelCell.m
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2018 netease. All rights reserved.
//

#import "XYJDetailLabelCell.h"

static CGFloat kCellHeight = 102.0;

@interface XYJDetailLabelCell ()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation XYJDetailLabelCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.topLabel];
        [self.contentView addSubview:self.bottomLabel];
        [self.contentView addSubview:self.seperatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 25.0;
    CGFloat labelWidth = XYJScreenWidth() - padding * 2;
    self.topLabel.frame = CGRectMake(padding, padding, labelWidth, 13);
    self.bottomLabel.frame = CGRectMake(padding, kCellHeight - padding - 17, labelWidth, 17);
    self.seperatorView.frame = CGRectMake(padding, kCellHeight - 0.5, labelWidth, 0.5);
}

#pragma mark - Getter & Setter

- (UILabel *)topLabel {
    if (_topLabel == nil) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont fontWithName:XYJ_Regular_Font size:11];
        _topLabel.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color alpha:0.5];
    }
    return _topLabel;
}

- (UILabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont fontWithName:XYJ_Regular_Font size:15];
        _bottomLabel.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color];
    }
    return _bottomLabel;
}

- (UIView *)seperatorView {
    if (_seperatorView == nil) {
        _seperatorView = [[UIView alloc] init];
        _seperatorView.backgroundColor = [XYJColorUtils colorWithHexString:XYJ_Line_Color];
    }
    return _seperatorView;
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
//        self.rightLabel.text = rightContent;
    }
}

- (void)setTextForLineOne:(NSString *)lineOneText lineTwo:(NSString *)lineTwoText {
    self.style = XYJDetailLabelCellStyleLabel;
    self.topLabel.text = lineOneText;
    self.bottomLabel.text = lineTwoText;
}

+ (CGFloat)height {
    return kCellHeight;
}

@end
