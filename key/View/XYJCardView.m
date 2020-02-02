//
//  XYJCardView.m
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJCardView.h"

@interface XYJCardView ()

@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UIImageView *bgImageView;

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
    CGFloat padding = 25;
    self.shadowImageView.frame = self.bounds;
    self.bgImageView.frame = CGRectMake(padding, padding, self.bounds.size.width - padding * 2, self.bounds.size.height - padding * 2);
}

#pragma mark - Initialization

- (void)initUI {
    [self addSubview:self.shadowImageView];
    [self addSubview:self.bgImageView];
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

@end
