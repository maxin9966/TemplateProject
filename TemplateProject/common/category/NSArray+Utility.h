//
//  NSArray+Utility.h
//  MeiMei
//
//  Created by 马鑫 on 14-8-28.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utility)

//是否存在相同的object
- (BOOL)hasObj:(id<NSObject>)object;

- (id)objectAtIndexSafely:(NSUInteger)index;

@end

@interface NSMutableArray (Utility)

//如果已存在 则不重复添加
- (BOOL)addObjectNonrepetitive:(id<NSObject>)object;

//删除所有相同的object
- (BOOL)deleteObj:(id<NSObject>)object;

//安全添加
- (BOOL)addObjectSafely:(id)anObject;

@end
