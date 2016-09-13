//
//  PULoadImageOperation.m
//  gem
//
//  Created by admin on 15/11/2.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "PULoadImageOperation.h"

@interface PULoadImageOperation ()

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;

@end

@implementation PULoadImageOperation
@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;

- (id)initWithFilePath:(NSString *)filePath completion:(PULoadImageCompletion)completion
{
    self = [super init];
    if(self){
        self.filePath = filePath;
        self.completion = completion;
    }
    return self;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setCancelled:(BOOL)cancelled {
    [self willChangeValueForKey:@"isCancelled"];
    _cancelled = cancelled;
    [self didChangeValueForKey:@"isCancelled"];
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)start
{
    PULoadImageCompletion block = nil;
    NSString *path = nil;
    UIImage *image = nil;
    @synchronized (self) {
        block = self.completion;
        path = self.filePath;
        if(self.isCancelled || !self.filePath.length){
            self.finished = YES;
            [self reset];
            return;
        }
        self.executing = YES;
    }
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    if(data){
        image = [UIImage imageWithData:data];
        //解析图片
        [image resize:CGSizeMake(1, 1)];
    }
    [self done];
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL cancel;
        @synchronized (self) {
            cancel = self.isCancelled;
        }
        if(block && !cancel){
            block(image,error);
        }
    });
}

- (void)cancel
{
    [super cancel];
    @synchronized (self) {
        self.cancelled = YES;
    }
}

- (void)done {
    @synchronized (self) {
        self.finished = YES;
        self.executing = NO;
    }
    [self reset];
}

- (void)reset {
    @synchronized (self) {
        self.filePath = nil;
        self.completion = nil;
    }
}

@end
