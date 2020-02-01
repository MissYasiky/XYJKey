//
//  XYJHomeTabBar.h
//  key
//
//  Created by MissYasiky on 2020/2/1.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XYJHomeTabBarDelegate <NSObject>

- (void)selectTabBarAtIndex:(NSInteger)index;

@end

@interface XYJHomeTabBar : UIView

@property (nonatomic, weak) id<XYJHomeTabBarDelegate> delegate;

- (void)selectedAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
