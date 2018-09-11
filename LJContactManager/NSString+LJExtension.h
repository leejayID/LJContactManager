//
//  NSString+LJExtension.h
//  Demo
//
//  Created by LeeJay on 2018/7/5.
//  Copyright © 2018年 LeeJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LJExtension)

/**
 去除手机号的特殊字段

 @param string 手机号
 @return 处理过的手机号
 */
+ (NSString *)lj_filterSpecialString:(NSString *)string;

/**
 字符串转拼音

 @param string 字符串
 @return 拼音
 */
+ (NSString *)lj_pinyinForString:(NSString *)string;

@end
