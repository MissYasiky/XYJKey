//
//  XYJDetailLabelCell.m
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2018 netease. All rights reserved.
//

#import "XYJDetailLabelCell.h"
#import "NSString+Util.h"

static CGFloat kCellHeight = 102.0;

@interface XYJDetailLabelCell ()<
UITextFieldDelegate
>

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UIImageView *indicatorImageView; // 暂时没用上该控件
@property (nonatomic, strong) UITextField *textField;

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
        [self.contentView addSubview:self.indicatorImageView];
        [self.contentView addSubview:self.textField];
        
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] init];
        [gesture addTarget:self action:@selector(longPressAction)];
        [self.contentView addGestureRecognizer:gesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = XYJ_ScreenWidth;
    CGFloat height = kCellHeight;
    CGFloat xPadding = 25.0;
    CGFloat labelWidth = width - xPadding * 2;
    
    self.topLabel.frame = CGRectMake(xPadding, xPadding, labelWidth, 13);
    self.bottomLabel.frame = CGRectMake(xPadding, height - xPadding - 17, labelWidth, 17);
    self.seperatorView.frame = CGRectMake(xPadding, height - 0.5, labelWidth, 0.5);
    self.indicatorImageView.frame = CGRectMake(width - xPadding - 20, (height - 16) / 2.0, 20, 16);
    self.textField.frame = CGRectMake(xPadding, 63, labelWidth, 28);
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

- (UIImageView *)indicatorImageView {
    if (_indicatorImageView == nil) {
        _indicatorImageView = [[UIImageView alloc] init];
        [_indicatorImageView setImage:[UIImage imageNamed:@"list_indicator_arrow"]];
        _indicatorImageView.hidden = YES;
    }
    return _indicatorImageView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color];
        _textField.font = [UIFont fontWithName:XYJ_Regular_Font size:15];
        _textField.hidden = YES;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)setStyle:(XYJDetailLabelCellStyle)style {
    if (style == _style) {
        return;
    }
    _style = style;
    
    switch (style) {
        case XYJDetailLabelCellStyleLabel:
        {
            self.indicatorImageView.hidden = YES;
            self.bottomLabel.hidden = NO;
            self.textField.hidden = YES;
            break;
        }
        case XYJDetailLabelCellStyleTextField:
        {
            self.indicatorImageView.hidden = YES;
            self.bottomLabel.hidden = YES;
            self.textField.hidden = NO;
            break;
        }
        default:
            break;
    }
}

- (void)setTextFieldStyle:(XYJDetailLabelCellTextFieldStyle)textFieldStyle {
    if (textFieldStyle == _textFieldStyle) {
        return;
    }
    _textFieldStyle = textFieldStyle;
    
    switch (textFieldStyle) {
        case XYJDetailLabelCellTextFieldStyleChinese:
        {
            self.textField.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        }
        case XYJDetailLabelCellTextFieldStyleNumber:
        {
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case XYJDetailLabelCellTextFieldStyleDate:
        {
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case XYJDetailLabelCellTextFieldStyleCVV:
        {
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        default:
            break;
    }
}

#pragma mark - Action

- (void)longPressAction {
    if (self.style != XYJDetailLabelCellStyleLabel) {
        return;
    }
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.bottomLabel.text;
    if (self.delegate) {
        NSString *message = pasteBoard.string ? @"拷贝成功" : @"拷贝失败";
        [self.delegate detailLabelCell_showToast:message];
    }
}

#pragma mark - Public

- (void)setTextForLineOne:(NSString *)lineOneText lineTwo:(NSString *)lineTwoText {
    self.style = XYJDetailLabelCellStyleLabel;
    self.topLabel.text = lineOneText;
    self.bottomLabel.text = lineTwoText;
}

- (void)setTextForTitle:(NSString *)text content:(NSString *)content placeHolder:(NSString *)placeHolder {
    self.style = XYJDetailLabelCellStyleTextField;
    self.topLabel.text = text;
    
    if (content) {
        self.textField.text = content;
        self.enterContent = content;
    }
    
    if (placeHolder && placeHolder.length > 0) {
        NSDictionary *placeHolderAttributes = @{NSFontAttributeName:[UIFont fontWithName:XYJ_Regular_Font size:15],
                                          NSForegroundColorAttributeName:[XYJColorUtils colorWithHexString:XYJ_Text_Color alpha:0.5]
        };
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:placeHolderAttributes];
    }
}

+ (CGFloat)height {
    return kCellHeight;
}

#pragma mark - Private

- (NSString *)correctEnter:(NSString *)text {
    if (self.textFieldStyle == XYJDetailLabelCellTextFieldStyleChinese) {
        return text;
    }
    
    NSString *scanString = [text xyj_scanForNumber];
    
    if (self.textFieldStyle == XYJDetailLabelCellTextFieldStyleDate) {
        if (scanString.length > 4) {
            scanString = [scanString substringToIndex:4];
        }
        return scanString;
    } else if (self.textFieldStyle == XYJDetailLabelCellTextFieldStyleCVV) {
        if (scanString.length > 3) {
            scanString = [scanString substringToIndex:3];
        }
        return scanString;
    } else if (self.textFieldStyle == XYJDetailLabelCellTextFieldStyleNumber) {
        if (scanString.length > 21) {
            scanString = [scanString substringToIndex:21];
        }
        return [scanString xyj_seperateEveryFourNumber];
    }
    return nil;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidChange:(UITextField *)textField {
    NSString *correctText = [self correctEnter:textField.text];
    self.textField.text = correctText;
    self.enterContent = correctText;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *correctText = [self correctEnter:textField.text];
    self.textField.text = correctText;
    self.enterContent = correctText;
}

@end
