//
//  NSDictionary+Utility.m
//  FansKit
//
//  Created by MA on 14/12/12.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)


//返回非NULL
- (id)objectForKeySafely:(id <NSCopying>)aKey
{
    id value = [self objectForKey:aKey];
    if([value isKindOfClass:[NSNull class]]){
        value = nil;
    }
    return value;
}

//返回非NULL字符串 @""
- (NSString*)stringForKeyNonNil:(id <NSCopying>)aKey
{
    id value = [self objectForKey:aKey];
    if([value isKindOfClass:[NSNull class]]){
        value = @"";
    }
    return value;
}

@end

@implementation NSMutableDictionary (Utility)

- (void)setObjectSafely:(id)obj forKey:(id <NSCopying>)aKey
{
    if(!obj){
        return;
    }
    [self setObject:obj forKey:aKey];
}

@end
