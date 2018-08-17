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
 通讯录的名字处理

 @param string 名字
 @return 处理过的名字
 */
+ (NSString *)lj_firstCharacterWithString:(NSString *)string;

@end
