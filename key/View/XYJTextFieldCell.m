//
//  XYJTextFieldCell.m
//  key
//
//  Created by MissYasiky on 2018/11/21.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJTextFieldCell.h"

static CGFloat kCellHeight = 42.0;
static CGFloat kRightPad = 15.0;

@interface XYJTextFieldCell ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation XYJTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = [UIFont systemFontOfSize:18];
        self.textLabel.textColor = XYJColor(0x696969, 1.0);
        
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = CGRectMake(120, (kCellHeight - 20)/2.0, XYJScreenWidth() - 120 - kRightPad, 20);
}

#pragma mark - Getter & Setter

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textColor = XYJColor(0xa4a4a4, 1.0);
        _textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}
                           
#pragma mark - Public

- (void)setTextFieldTag:(NSInteger)tag
            placeholder:(NSString *)text
               delegate:(id<UITextFieldDelegate>)delegate
           keyboardTyep:(UIKeyboardType)type {
    self.textField.tag = tag;
    if (text != nil && text.length != 0) {
        self.textField.placeholder = text;
    }
    self.textField.delegate = delegate;
    self.textField.keyboardType = type;
}

- (void)setLeftLabelText:(NSString *)leftContent textFieldContent:(NSString *)rightContent {
    if (leftContent != nil && leftContent.length != 0) {
        self.textLabel.text = leftContent;
    }
    if (rightContent != nil && rightContent.length != 0) {
        self.textField.text = rightContent;
    }
}

+ (CGFloat)height {
    return kCellHeight;
}

@end
