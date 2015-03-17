//
//  NSCoder+Utility.m
//  FansKit
//
//  Created by MA on 14/12/12.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "NSCoder+Utility.h"

@implementation NSCoder (Utility)

- (id)decodeObjectForKeySafely:(NSString *)aKey
{
    id value = [self decodeObjectForKey:aKey];
    if([value isKindOfClass:[NSNull class]]){
        value = nil;
    }
    return value;
}

@end
