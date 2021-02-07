//
//  XYJCardModel.h
//  key
//
//  Created by MissYasiky on 2020/11/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYJCardModel : NSObject

@property (nonatomic, assign) NSTimeInterval createTime;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *accountNum;

@property (nonatomic, copy) NSString *validThru;

@property (nonatomic, copy) NSString *cvv2;

@property (nonatomic, assign) int creditCard;

@property (nonatomic, assign) int myOwn;

@property (nonatomic, strong) NSDictionary *externDict;

@end

NS_ASSUME_NONNULL_END
