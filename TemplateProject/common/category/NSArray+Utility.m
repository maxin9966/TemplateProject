//
//  NSArray+Utility.m
//  MeiMei
//
//  Created by 马鑫 on 14-8-28.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import "NSArray+Utility.h"

@implementation NSArray (Utility)

//是否存在相同的object
- (BOOL)hasObj:(id<NSObject>)object
{
    if(!object){
        return NO;
    }
    for(id<NSObject> obj in self){
        if(obj==object || [obj isEqual:object]){
            return YES;
        }
    }
    return NO;
}

@end

@implementation NSMutableArray (Utility)

- (BOOL)addObjectNonrepetitive:(id<NSObject>)object
{
    if(!object){
        return NO;
    }
    for(id<NSObject> obj in self){
        if(obj==object || [object isEqual:obj]){
            return NO;
        }
    }
    [self addObject:object];
    return YES;
}

//删除所有相同的object
- (BOOL)deleteObj:(id<NSObject>)object
{
    if(!object){
        return NO;
    }
    BOOL isDelete = NO;
    for(NSInteger i=0;i<self.count;i++){
        id<NSObject> obj = [self objectAtIndex:i];
        if(obj==object || [obj isEqual:object]){
            [self removeObjectAtIndex:i];
            isDelete = YES;
            i--;
        }
    }
    return isDelete;
}

@end
