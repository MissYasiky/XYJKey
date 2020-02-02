//
//  XYJHomeListCell.m
//  key
//
//  Created by MissYasiky on 2020/2/1.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJHomeListCell.h"

static CGFloat const kCellHeight = 90.0;

@interface XYJHomeListCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *midLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *taLabel;
@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation XYJHomeListCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.indicatorImageView];
        [self.contentView addSubview:self.topLabel];
        [self.contentView addSubview:self.midLabel];
        [self.contentView addSubview:self.bottomLabel];
        [self.contentView addSubview:self.taLabel];
        [self.contentView addSubview:self.seperatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = XYJScreenWidth();
    CGFloat height = kCellHeight;
    CGFloat xPadding = 25.0;
    self.iconImageView.frame = CGRectMake(xPadding, (height - 44) / 2.0, 44, 44);
    self.indicatorImageView.frame = CGRectMake(width - xPadding - 20, (height - 16) / 2.0, 20, 16);
    
    CGFloat originX = 94.0;
    CGFloat labelWidth = self.indicatorImageView.frame.origin.x - originX;
    self.topLabel.frame = CGRectMake(originX, 13, labelWidth, 17);
    self.midLabel.frame = CGRectMake(originX, 33, labelWidth, 13);
    self.bottomLabel.frame = CGRectMake(originX, 60, labelWidth, 17);
    self.seperatorView.frame = CGRectMake(originX, height - 0.5, width - originX - xPadding, 0.5);
    
    self.taLabel.frame = CGRectMake(self.indicatorImageView.frame.origin.x - 22, (height - 25) / 2.0, 22, 25);
}

#pragma mark - Getter & Setter

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView setImage:[UIImage imageNamed:@"home_list_icon_card"]];
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

- (UILabel *)topLabel {
    if (_topLabel == nil) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont fontWithName:XYJ_Regular_Font size:15];
        _topLabel.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color];
        _topLabel.text = @"招商银行";
    }
    return _topLabel;
}

- (UILabel *)midLabel {
    if (_midLabel == nil) {
        _midLabel = [[UILabel alloc] init];
        _midLabel.font = [UIFont fontWithName:XYJ_Regular_Font size:11];
        _midLabel.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color alpha:0.5];
        _midLabel.text = @"借记卡";
    }
    return _midLabel;
}

- (UILabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont fontWithName:XYJ_Regular_Font size:15];
        _bottomLabel.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color];
        _bottomLabel.text = @"4444 1111 4444 2222 6489";
    }
    return _bottomLabel;
}

- (UILabel *)taLabel {
    if (_taLabel == nil) {
        _taLabel = [[UILabel alloc] init];
        UIColor *bgColor = [UIColor colorWithRed:0xdd/255.0
                               green:0x57/255.0
                                blue:0x57/255.0
                               alpha:0.2];
        UIColor *color = [UIColor colorWithRed:0xdd/255.0
                               green:0x57/255.0
                                blue:0x57/255.0
                               alpha:1];
        _taLabel.backgroundColor = bgColor;
        _taLabel.font = [UIFont fontWithName:XYJ_Bold_Font size:13];
        _taLabel.textColor = color;
        _taLabel.textAlignment = NSTextAlignmentCenter;
        _taLabel.layer.cornerRadius = 4;
        _taLabel.layer.masksToBounds = YES;
        _taLabel.text = @"TA";
    }
    return _taLabel;
}

- (UIView *)seperatorView {
    if (_seperatorView == nil) {
        _seperatorView = [[UIView alloc] init];
        _seperatorView.backgroundColor = [XYJColorUtils colorWithHexString:XYJ_Line_Color];
    }
    return _seperatorView;
}

#pragma mark - Public

+ (CGFloat)height {
    return kCellHeight;
}

@end
