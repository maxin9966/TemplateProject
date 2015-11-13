//
//  MXOperations.m
//  gem
//
//  Created by admin on 15/8/31.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MXOperations.h"

@interface MXOperations()
{
    NSMutableArray *ops;
}


@end

@implementation MXOperations
@synthesize isCancelled;

- (id)init
{
    self = [super init];
    if(self){
        ops = [NSMutableArray array];
    }
    return self;
}

- (void)addOperation:(id)op
{
    if(!op){
        return;
    }
    [ops addObject:op];
}

- (void)removeOperation:(id)op
{
    if(!op){
        return;
    }
    [ops removeObject:op];
}

- (void)cancel
{
    for(id op in ops){
        [op cancel];
    }
}

@end
