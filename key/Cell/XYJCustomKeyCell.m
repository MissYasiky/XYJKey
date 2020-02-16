//
//  XYJCustomKeyCell.m
//  key
//
//  Created by MissYasiky on 2020/2/16.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCustomKeyCell.h"

static CGFloat kCellHeight = 67.0;

@interface XYJCustomKeyCell ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *seperatorLine;
@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation XYJCustomKeyCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.button];
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.seperatorLine];
        [self.contentView addSubview:self.seperatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = XYJ_ScreenWidth;
    CGFloat height = kCellHeight;
    CGFloat xPadding = 25.0;
    CGFloat contentWidth = width - xPadding * 2;
    
    self.button.frame = CGRectMake(xPadding, (height - 23) / 2.0, 23, 23);
    self.label.frame = CGRectMake(self.button.frame.origin.x + self.button.frame.size.width + 10, (height - 22) / 2.0, 120, 22);
    self.seperatorLine.frame = CGRectMake(0, 0, 1, 23);
    self.seperatorLine.center = self.contentView.center;
    self.seperatorView.frame = CGRectMake(xPadding, height - 0.5, contentWidth, 0.5);
}

#pragma mark - Getter & Setter

- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:[UIImage imageNamed:@"list_btn_delete"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"添加自定义字段";
        _label.font = [UIFont fontWithName:XYJ_Regular_Font size:15];
        _label.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color];
        _label.hidden = YES;
    }
    return _label;
}

- (UIView *)seperatorLine {
    if (_seperatorLine == nil) {
        _seperatorLine = [[UIView alloc] init];
        _seperatorLine.backgroundColor = [XYJColorUtils colorWithHexString:XYJ_Line_Color];
    }
    return _seperatorLine;
}

- (UIView *)seperatorView {
    if (_seperatorView == nil) {
        _seperatorView = [[UIView alloc] init];
        _seperatorView.backgroundColor = [XYJColorUtils colorWithHexString:XYJ_Line_Color];
    }
    return _seperatorView;
}

- (void)setStyle:(XYJCustomKeyCellStyle)style {
    if (_style == style) {
        return;
    }
    _style = style;
    
    switch (style) {
        case XYJCustomKeyCellStyleKeyValue:
        {
            self.button.userInteractionEnabled = YES;
            [self.button setImage:[UIImage imageNamed:@"list_btn_delete"] forState:UIControlStateNormal];
            self.label.hidden = YES;
            self.seperatorLine.hidden = NO;
            break;
        }
        case XYJCustomKeyCellStyleAddKey:
        {
            self.button.userInteractionEnabled = NO;
            [self.button setImage:[UIImage imageNamed:@"list_btn_add"] forState:UIControlStateNormal];
            self.label.hidden = NO;
            self.seperatorLine.hidden = YES;
            break;
        }
        default:
            break;
    }
}

#pragma mark - Action

- (void)buttonAction {
    
}

#pragma mark - Public

+ (CGFloat)height {
    return kCellHeight;
}

@end
