//
//  NSObject+Utility.m
//  FansKit
//
//  Created by antsmen on 15-1-13.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "NSObject+Utility.h"

@implementation NSObject (Utility)

- (NSString *)JSONString
{
    if(![NSJSONSerialization isValidJSONObject:self]){
        return nil;
    }
    NSString *jsonString = nil;
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    if (jsonData.length>0){
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
