//
//  FormatChecker.h
//  zp_chu
//
//  Created by Jaffer on 2018/9/17.
//  Copyright © 2018年 yitai. All rights reserved.
//

#import <Foundation/Foundation.h>

//https://www.jianshu.com/p/2f5bb0a419fa

@interface FormatChecker : NSObject

/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;


/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)hasEmoji:(NSString*)string;


/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
+ (BOOL)isNineKeyBoard:(NSString *)string;


//-----过滤字符串中的emoji
+ (NSString *)disable_emoji:(NSString *)text;


/**
 * 判断 字母、数字、中文
 */
+ (BOOL)isInputRuleAndNumber:(NSString *)str;


@end
