//
//  XYJCardView.h
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XYJCard;

@interface XYJCardView : UIView

- (instancetype)initWithCard:(XYJCard *)card;

- (void)updateCard:(XYJCard *)card;

@end

NS_ASSUME_NONNULL_END
