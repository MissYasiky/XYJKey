//
//  XYJTextViewCell.m
//  key
//
//  Created by MissYasiky on 2018/11/21.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJTextViewCell.h"

static CGFloat kCellHeight = 100.0;
static CGFloat kPad = 15.0;

@implementation XYJTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.textView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = CGRectMake(kPad, kPad, XYJScreenWidth() - kPad * 2, kCellHeight - kPad * 2);
}

#pragma mark - Getter & Setter

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = XYJColor(0xa4a4a4, 1.0);
    }
    return _textView;
}

#pragma mark - Public

- (void)setTextViewContent:(NSString *)content{
    self.textView.text = content;
}

+ (CGFloat)height {
    return kCellHeight;
}

@end
