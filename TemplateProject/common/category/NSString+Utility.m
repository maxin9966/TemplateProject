//
//  NSString+Utility.m
//  FansKit
//
//  Created by MA on 14/12/9.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

- (BOOL)isChinese
{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

- (BOOL)noNilEqualToString:(NSString*)aString
{
    NSString *string_1 = self;
    NSString *string_2 = aString;
    if(!string_1){
        string_1 = @"";
    }
    if(!string_2){
        string_2 = @"";
    }
    return [string_1 isEqualToString:string_2];
}

//隐藏某段 用字符替代
- (NSString*)hideInPosition:(MXStringPosition)positionType number:(NSUInteger)number replaceChar:(unichar)aChar
{
    if(!self.length){
        return self;
    }
    NSUInteger loc = 0;
    NSUInteger len = 0;
    len = number>self.length?self.length:number;
    switch (positionType) {
        case MXStringPositionFront:
            loc = 0;
            break;
        case MXStringPositionMiddle:
            loc = self.length/2-len/2;
            break;
        case MXStringPositionEnding:
            loc = self.length-len;
            break;
        default:
            break;
    }
    NSRange range = NSMakeRange(loc, len);
    NSMutableString *charString = [NSMutableString string];
    for(int i=0;i<len;i++){
        [charString appendFormat:@"%c",aChar];
    }
    return [self stringByReplacingCharactersInRange:range withString:charString];
}

- (NSURL*)url
{
    if(self.isAbsolutePath){
        return [NSURL fileURLWithPath:self];
    }else{
        return [NSURL URLWithString:self];
    }
}

@end

@implementation NSString (Serializable)

//UIColor反序列化
- (UIColor*)colorReverseSerializable
{
    if(!self.length){
        return nil;
    }
    NSArray* components = [self componentsSeparatedByString:@","];
    CGFloat r = [[components objectAtIndex:0] floatValue];
    CGFloat g = [[components objectAtIndex:1] floatValue];
    CGFloat b = [[components objectAtIndex:2] floatValue];
    CGFloat a = [[components objectAtIndex:3] floatValue];
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end

@implementation UIColor (Serializable)

//color序列化
- (NSString*)colorSerializable
{
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    NSString* colorAsString = [NSString stringWithFormat:@"%f,%f,%f,%f",components[0], components[1],components[2],components[3]];
    return colorAsString;
}

@end
