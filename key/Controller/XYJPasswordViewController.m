//
//  XYJPasswordViewController.m
//  key
//
//  Created by MissYasiky on 2018/12/4.
//  Copyright © 2018 netease. All rights reserved.
//

#import "XYJPasswordViewController.h"
#import "XYJViewController.h"
#import "NSString+XYJMess.h"

@interface XYJPasswordViewController ()<
UITextViewDelegate
>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSArray<UILabel *> *labelArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation XYJPasswordViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textView];
    [self addLabels];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)dealloc {
    _textView.delegate = nil;
}

#pragma mark - Getter & Setter

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(90, 260, XYJScreenWidth() - 90 * 2, 37);
        _textView.delegate = self;
        _textView.hidden = YES;
    }
    return _textView;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"HHmm";
    }
    return _dateFormatter;
}

#pragma mark - Private

- (void)addLabels {
    NSMutableArray *muArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    CGFloat width = 30.0;
    CGFloat span = 30.0;
    CGFloat originX = (XYJScreenWidth() - width * 4 - span * 3)/2.0;
    
    for(int i = 0; i < 4; i++) {
        UILabel *label= [[UILabel alloc] init];
        label.frame = CGRectMake(originX + i * (width + span), 200, width, 35);
        label.text = @"-";
        label.font = [UIFont systemFontOfSize:45];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = XYJColor(0x696969, 1.0);
        [muArray addObject:label];
        [self.view addSubview:label];
    }
    
    self.labelArray = [muArray mutableCopy];
}

- (BOOL)isPasswordCorrect:(NSString *)password {
    if (password.length != 4) {
        return NO;
    }
    NSString *timeString = [self.dateFormatter stringFromDate:[NSDate date]];
    NSInteger hour = [[timeString substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger min = [[timeString substringWithRange:NSMakeRange(2, 2)] integerValue];
    NSInteger passwordPartOne = [[password substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger passwordPartTwo = [[password substringWithRange:NSMakeRange(2, 2)] integerValue];
    if (hour + 12 == passwordPartOne && min + 4 == passwordPartTwo) {
        return YES;
    }
    return NO;
}

#pragma mark - UITextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return (text.length == 0 || [text xyj_isSingleNumber]);
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *content = textView.text;
    if (content.length > 4) {
        textView.text = [content substringToIndex:4];
    }
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = self.labelArray[i];
        if (i < textView.text.length) {
            label.text = [textView.text substringWithRange:NSMakeRange(i, 1)];
        } else {
            label.text = @"-";
        }
    }
    
    if ((textView.text.length == 4) && [self isPasswordCorrect:textView.text]) {
        [self.textView resignFirstResponder];
        XYJViewController *vctrl = [[XYJViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vctrl];
        [UIApplication sharedApplication].keyWindow.rootViewController = navi;
    }
}

@end
