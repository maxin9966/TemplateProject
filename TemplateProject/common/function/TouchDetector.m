//
//  TouchDetector.m
//  ASTouchVisualizer
//
//  Created by antsmen on 15-1-23.
//  Copyright (c) 2015年 AutreSphere. All rights reserved.
//

#import "TouchDetector.h"
#import <objc/runtime.h>

NSString *const kTouchDetectorDidReceiveEvent = @"kTouchDetectorDidReceiveEvent";

@implementation TouchDetector

+ (id)sharedInstance
{
    static TouchDetector *touchDetector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        touchDetector = [[self alloc] init];
    });
    return touchDetector;
}

+ (void)install
{
    [[self class] sharedInstance];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [self setupEventHandler];
    }
    return self;
}

- (void)setupEventHandler
{
    Method original, swizzle;
    
    //方法交换实现
    original = class_getInstanceMethod([UIWindow class], @selector(sendEvent:));
    swizzle = class_getInstanceMethod([UIWindow class], @selector(swizzled_sendEvent:));
    method_exchangeImplementations(original, swizzle);
}

- (void)receiveTouches:(NSSet *)touches
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTouchDetectorDidReceiveEvent object:touches userInfo:nil];
}

@end

@interface UIWindow (TouchVisualizer)
@end

@implementation UIWindow (TouchVisualizer)

//与sendEvent方法交换实现
- (void)swizzled_sendEvent:(UIEvent *)event
{
    [[TouchDetector sharedInstance] receiveTouches:event.allTouches];
    [self swizzled_sendEvent:event];
}

@end
