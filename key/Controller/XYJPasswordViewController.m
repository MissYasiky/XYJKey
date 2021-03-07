//
//  XYJPasswordViewController.m
//  key
//
//  Created by MissYasiky on 2018/12/4.
//  Copyright © 2018 netease. All rights reserved.
//

#import "XYJPasswordViewController.h"
#import "XYJHomeViewController.h"
#import "XYJSecrecyManager.h"

@interface XYJPasswordViewController ()<
UITextViewDelegate
>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSArray<UILabel *> *labelArray;

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
        _textView.frame = CGRectMake(90, 260, XYJ_ScreenWidth - 90 * 2, 37);
        _textView.delegate = self;
        _textView.hidden = YES;
    }
    return _textView;
}

#pragma mark - Private

- (void)addLabels {
    NSMutableArray *muArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    CGFloat width = 30.0;
    CGFloat span = 30.0;
    CGFloat originX = (XYJ_ScreenWidth - width * 4 - span * 3)/2.0;
    
    for(int i = 0; i < 4; i++) {
        UILabel *label= [[UILabel alloc] init];
        label.frame = CGRectMake(originX + i * (width + span), 260, width, 35);
        label.text = @"-";
        label.font = [UIFont systemFontOfSize:45];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [XYJColorUtils colorWithHexString:@"0x696969"];
        [muArray addObject:label];
        [self.view addSubview:label];
    }
    
    self.labelArray = [muArray mutableCopy];
}

- (void)jumpToHomeView {
    [[XYJSecrecyManager sharedManager] unlockForSeconds];
    
    XYJHomeViewController *vctrl = [[XYJHomeViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vctrl];
    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
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
    
    if ((textView.text.length == 4) &&
        [[XYJSecrecyManager sharedManager] isPasswordCorrect:textView.text]) {
        [self.textView resignFirstResponder];
        [self jumpToHomeView];
    }
}

@end
