//
//  MXOperations.h
//  gem
//
//  Created by admin on 15/8/31.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXOperations : NSObject

@property (nonatomic,assign) BOOL isCancelled;

- (void)addOperation:(id)op;

- (void)removeOperation:(id)op;

- (void)cancel;

@end
