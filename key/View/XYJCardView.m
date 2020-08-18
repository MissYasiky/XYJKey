//
//  XYJCardView.m
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCardView.h"

#define XYJCardTextColor @"0xC1D9F5"

@interface XYJCardView ()

@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *cvvLabel;
@property (nonatomic, strong) UILabel *ownerLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation XYJCardView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat cardPadding = 25;
    CGFloat cardWidth = self.bounds.size.width - cardPadding * 2;
    CGFloat cardHeight = self.bounds.size.height - cardPadding * 2;
    self.shadowImageView.frame = self.bounds;
    self.bgImageView.frame = CGRectMake(cardPadding, cardPadding, cardWidth, cardHeight);
    
    CGFloat padding = 20;
    self.numLabel.frame = CGRectMake(padding, 35, self.bounds.size.width - 2 * padding, 20);
    self.typeLabel.frame = CGRectMake(padding, 71, 80, 15);
    self.cvvLabel.frame = CGRectMake(cardWidth - padding - 80, 71, 80, 15);
    
    CGFloat littleLabelHeight = 11;
    CGFloat middleLabelHeight = 14;
    self.leftLabel.frame = CGRectMake(40, cardHeight - 60 - littleLabelHeight, 80, littleLabelHeight);
    self.ownerLabel.frame = CGRectMake(40, cardHeight - 40 - middleLabelHeight, 80, middleLabelHeight);
    
    self.rightLabel.frame = CGRectMake(cardWidth - padding - 65, cardHeight - 60 - littleLabelHeight, 65, littleLabelHeight);
    self.dateLabel.frame = CGRectMake(cardWidth - padding - 65, cardHeight - 40 - middleLabelHeight, 65, middleLabelHeight);
}

#pragma mark - Initialization

- (void)initUI {
    [self addSubview:self.shadowImageView];
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.numLabel];
    [self.bgImageView addSubview:self.typeLabel];
    [self.bgImageView addSubview:self.cvvLabel];
    [self.bgImageView addSubview:self.leftLabel];
    [self.bgImageView addSubview:self.rightLabel];
    [self.bgImageView addSubview:self.ownerLabel];
    [self.bgImageView addSubview:self.dateLabel];
}

#pragma mark - Getter & Setter

- (UIImageView *)shadowImageView {
    if (_shadowImageView == nil) {
        _shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_bg_shadow"]];
    }
    return _shadowImageView;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_bg"]];
    }
    return _bgImageView;
}

- (UILabel *)numLabel {
    if (_numLabel == nil) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont fontWithName:XYJ_Bold_Font size:19];
        _numLabel.textColor = [XYJColorUtils colorWithHexString:XYJCardTextColor];
        _numLabel.text = @"6217 8880 9868 7657 289";
    }
    return _numLabel;
}

- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont fontWithName:XYJ_Bold_Font size:12];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.text = @"借记卡";
    }
    return _typeLabel;
}

- (UILabel *)cvvLabel {
    if (_cvvLabel == nil) {
        _cvvLabel = [[UILabel alloc] init];
        _cvvLabel.font = [UIFont fontWithName:XYJ_Bold_Font size:12];
        _cvvLabel.textColor = [XYJColorUtils colorWithHexString:XYJCardTextColor];
        _cvvLabel.textAlignment = NSTextAlignmentRight;
        _cvvLabel.text = @"CVV2/423";
    }
    return _cvvLabel;
}

- (UILabel *)leftLabel {
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont fontWithName:XYJ_Regular_Font size:9];
        _leftLabel.textColor = [XYJColorUtils colorWithHexString:XYJCardTextColor];
        _leftLabel.text = @"CARD HOLDER";
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont fontWithName:XYJ_Regular_Font size:9];
        _rightLabel.textColor = [XYJColorUtils colorWithHexString:XYJCardTextColor];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.text = @"MONTH/YEAR";
    }
    return _rightLabel;
}

- (UILabel *)ownerLabel {
    if (_ownerLabel == nil) {
        _ownerLabel = [[UILabel alloc] init];
        _ownerLabel.font = [UIFont fontWithName:XYJ_Bold_Font size:12];
        _ownerLabel.textColor = [UIColor whiteColor];
        _ownerLabel.text = @"SOMEBODY";
    }
    return _ownerLabel;
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont fontWithName:XYJ_Bold_Font size:12];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.text = @"09/29";
    }
    return _dateLabel;
}

@end
