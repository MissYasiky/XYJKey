//
//  NSString+Util.h
//  key
//
//  Created by MissYasiky on 2018/12/17.
//  Copyright © 2018 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

/**
 是否是个位数数字的字符串
 */
- (BOOL)xyj_isSingleNumber;

/**
 是否是纯数字字符串
 */
- (BOOL)xyj_isPureNumber;

/**
 返回字符串中的数字字符串
*/
- (NSString *)xyj_scanForNumber;

/**
 将纯数字字符串每四位用一个空格分隔开
 */
- (NSString *)xyj_seperateEveryFourNumber;

/**
 对字符串进行混淆
 */
- (NSString *)xyj_mess;

/**
 对字符串进行反混淆
 */
- (NSString *)xyj_revert;

/**
 对字符串进行base64编码
 */
- (NSString *)xyj_encode;

/**
 对字符串进行base64解码
 */
- (NSString *)xyj_decode;

@end
