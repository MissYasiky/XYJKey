//
//  XYJCustomKeyCell.m
//  key
//
//  Created by MissYasiky on 2020/2/16.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCustomKeyCell.h"

static CGFloat kCellHeight = 67.0;

@interface XYJCustomKeyCell ()<
UITextFieldDelegate
>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *seperatorLine;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UITextField *keyTextField;
@property (nonatomic, strong) UITextField *valueTextField;

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
        [self.contentView addSubview:self.keyTextField];
        [self.contentView addSubview:self.valueTextField];
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
     
    CGFloat textFieldOriginX = xPadding + self.button.frame.size.width + 10;
    CGFloat textFieldWidth = width / 2 - textFieldOriginX - 10;
    CGFloat textFieldHeight = 18;
    CGFloat textFieldOriginY = (height - textFieldHeight) / 2.0;
    self.keyTextField.frame = CGRectMake(textFieldOriginX, textFieldOriginY, textFieldWidth, textFieldHeight);
    
    textFieldOriginX = width / 2 + 10;
    textFieldWidth = width / 2 - 10 - 25;
    self.valueTextField.frame = CGRectMake(textFieldOriginX, textFieldOriginY, textFieldWidth, textFieldHeight);
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

- (UITextField *)keyTextField {
    if (!_keyTextField) {
        _keyTextField = [[UITextField alloc] init];
        _keyTextField.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color];
        _keyTextField.font = [UIFont fontWithName:XYJ_Regular_Font size:15];
        _keyTextField.delegate = self;
        [_keyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _keyTextField;
}

- (UITextField *)valueTextField {
    if (!_valueTextField) {
        _valueTextField = [[UITextField alloc] init];
        _valueTextField.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color];
        _valueTextField.font = [UIFont fontWithName:XYJ_Regular_Font size:15];
        _valueTextField.delegate = self;
        [_valueTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _valueTextField;
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
            self.keyTextField.hidden = NO;
            self.valueTextField.hidden = NO;
            break;
        }
        case XYJCustomKeyCellStyleAddKey:
        {
            self.button.userInteractionEnabled = NO;
            [self.button setImage:[UIImage imageNamed:@"list_btn_add"] forState:UIControlStateNormal];
            self.label.hidden = NO;
            self.seperatorLine.hidden = YES;
            self.keyTextField.hidden = YES;
            self.valueTextField.hidden = YES;
            break;
        }
        default:
            break;
    }
}

#pragma mark - Action

- (void)buttonAction {
    if (self.didTapDeleteButton) {
        self.didTapDeleteButton(self.indexIdentifier.integerValue);
    }
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.didTextFieldBeginEditing) {
        self.didTextFieldBeginEditing([self.indexIdentifier integerValue]);
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.didTextFieldChanged == nil) {
        return;
    }
    
    self.didTextFieldChanged([self.indexIdentifier integerValue], self.keyTextField.text, self.valueTextField.text);
}

#pragma mark - Public

- (void)setKey:(NSString *)key value:(NSString *)value {
    self.keyTextField.text = key;
    self.valueTextField.text = value;
}

+ (CGFloat)height {
    return kCellHeight;
}

@end
