//
//  NSString+LJExtension.m
//  Demo
//
//  Created by LeeJay on 2018/7/5.
//  Copyright © 2018年 LeeJay. All rights reserved.
//

#import "NSString+LJExtension.h"

@implementation NSString (LJExtension)

+ (NSString *)lj_filterSpecialString:(NSString *)string
{
    if (string == nil)
    {
        return @"";
    }
    
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

+ (NSString *)lj_firstCharacterWithString:(NSString *)string
{
    if (string.length == 0)
    {
        return @"#";
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    
    NSMutableString *pinyinString = [[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] mutableCopy];
    NSString *str = [string substringToIndex:1];
    
    // 多音字处理http://blog.csdn.net/qq_29307685/article/details/51532147
    if ([str isEqualToString:@"长"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([str isEqualToString:@"沈"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([str isEqualToString:@"厦"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([str isEqualToString:@"地"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 2) withString:@"di"];
    }
    if ([str isEqualToString:@"重"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    
    NSString *upperStr = [[pinyinString substringToIndex:1] uppercaseString];
    
    NSString *regex = @"^[A-Z]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    NSString *firstCharacter = [predicate evaluateWithObject:upperStr] ? upperStr : @"#";
    
    return firstCharacter;
}

@end
