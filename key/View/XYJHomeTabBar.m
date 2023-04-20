//
//  XYJHomeTabBar.m
//  key
//
//  Created by MissYasiky on 2020/2/1.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJHomeTabBar.h"

static CGFloat const kHeight = 35.0;
static NSInteger const kButtonTag = 101;

@interface XYJHomeTabBar ()

@property (nonatomic, strong) NSArray <NSString *> *tabArray;
@property (nonatomic, strong) NSArray <UIButton *> *buttonArray;
@property (nonatomic, strong) UIView *selectedLine;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation XYJHomeTabBar

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tabArray = @[@"CARD", @"ACCOUNT"];
        _selectedIndex = -1;
        [self initUI];
    }
    return self;
}

#pragma mark - Initialization

- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    
    [self initButton];
    [self addSubview:self.selectedLine];
    
    [self selectedAtIndex:0];
}

- (void)initButton {
    NSInteger tabNumber = [self.tabArray count];
    
    CGFloat width = XYJ_ScreenWidth/tabNumber;
    CGFloat height = kHeight;
    
    NSMutableArray *buttonMuArray = [[NSMutableArray alloc] initWithCapacity:tabNumber];
    
    for (int i = 0; i < tabNumber; i++) {
        CGFloat originX = i * width;
        CGFloat originY = 0;
        UIButton *button = [self tabButtonWithTitle:self.tabArray[i] width:width height:height];
        button.frame = CGRectMake(originX, originY, width, height);
        button.tag = i + kButtonTag;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [buttonMuArray addObject:button];
        
        if (i == 0) {
            [button setSelected:YES];
        }
    }
    
    self.buttonArray = [buttonMuArray copy];
}

#pragma mark - Getter & Setter

- (UIView *)selectedLine {
    if (_selectedLine == nil) {
        CGFloat lineWidth = 25;
        CGFloat lineHeight = 2.5;
        _selectedLine = [[UIView alloc] init];
        _selectedLine.frame = CGRectMake(0, kHeight - lineHeight, lineWidth, lineHeight);
        _selectedLine.backgroundColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color];
    }
    return _selectedLine;
}

#pragma mark - Action

- (void)buttonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - kButtonTag;
    
    if (self.delegate) {
        [self.delegate selectTabBarAtIndex:index];
    }
    
    [self selectedAtIndex:index];
}

#pragma mark - Public

- (void)selectedAtIndex:(NSInteger)index {
    NSInteger tabNumber = [self.tabArray count];
    if (index < 0 || index >= tabNumber || index == self.selectedIndex) {
        return;
    }
    
    for (int i = 0; i < tabNumber; i++) {
        UIButton *button = self.buttonArray[i];
        [button setSelected:i == index];
    }
    
    CGFloat width = XYJ_ScreenWidth/tabNumber;
    CGFloat originX = index * width + (width - 25) / 2.0;
    CGRect originRect = self.selectedLine.frame;
    originRect.origin.x = originX;
    self.selectedLine.frame = originRect;
    
    self.selectedIndex = index;
}

#pragma mark - Private

- (UIButton *)tabButtonWithTitle:(NSString *)title width:(CGFloat)width height:(CGFloat)height {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:XYJ_Bold_Font size:13];
    [button setTitleColor:[XYJColorUtils colorWithHexString:XYJ_Text_Color alpha:0.5] forState:UIControlStateNormal];
    [button setTitleColor:[XYJColorUtils colorWithHexString:XYJ_Text_Color] forState:UIControlStateSelected];
    button.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    
    UIFont *font = [UIFont fontWithName:XYJ_Bold_Font size:13];
    NSDictionary *titleAttributes = @{NSFontAttributeName:font,
                                      NSKernAttributeName:@(3)};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:title attributes:titleAttributes];
    [button.titleLabel setAttributedText:string];
    return button;
}

@end
