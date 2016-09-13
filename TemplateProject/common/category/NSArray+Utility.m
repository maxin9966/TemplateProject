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

- (id)objectAtIndexSafely:(NSUInteger)index
{
    if(self.count<=index){
        return nil;
    }
    return [self objectAtIndex:index];
}

//随机获取一个对象
- (id)randomObject
{
    if(!self.count){
        return nil;
    }
    return [self objectAtIndexSafely:arc4random()%self.count];
}

@end

@implementation NSMutableArray (Utility)

- (BOOL)addObjectNoRepeat:(id<NSObject>)object
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

//安全添加
- (BOOL)addObjectSafely:(id)anObject
{
    if(!anObject){
        return NO;
    }
    [self addObject:anObject];
    return YES;
}

@end
