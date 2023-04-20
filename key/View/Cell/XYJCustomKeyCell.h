//
//  XYJCustomKeyCell.h
//  key
//
//  Created by MissYasiky on 2020/2/16.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYJCustomKeyCellStyle) {
    XYJCustomKeyCellStyleKeyValue = 0, // 默认 style，key-value输入框模式
    XYJCustomKeyCellStyleAddKey
};

NS_ASSUME_NONNULL_BEGIN

@interface XYJCustomKeyCell : UITableViewCell

@property (nonatomic, assign) XYJCustomKeyCellStyle style;

// 标记当前 cell 所在 indexPath：三位整数字符串，不足三位左侧补0
@property (nonatomic, assign) NSString *indexIdentifier;

@property (nonatomic, copy) void (^didTapDeleteButton)(NSInteger row);

@property (nonatomic, copy) void (^didTextFieldBeginEditing)(NSInteger row);

@property (nonatomic, copy) void (^didTextFieldChanged)(NSInteger row, NSString * _Nullable keyString, NSString * _Nullable valueString);

- (void)setKey:(NSString *)key value:(NSString *)value;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
