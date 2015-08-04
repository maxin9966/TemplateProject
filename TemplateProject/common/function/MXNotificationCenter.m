//
//  MXNotificationCenter.m
//  TemplateProject
//
//  Created by admin on 15/7/24.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MXNotificationCenter.h"
#import <objc/message.h>

/**
 
 Notification
 
 */

@implementation MXNotification

- (instancetype)initWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo
{
    if(!name.length){
        return nil;
    }
    self = [super init];
    if(self){
        _name = [name copy];
        _object = object;
        _userInfo = [userInfo copy];
    }
    return self;
}

@end

/**
 
 NotificationObserver
 
 */

@interface NotificationObserver : NSObject

@property (nonatomic,weak) id observer;
@property (nonatomic) SEL selector;
@property (nonatomic,copy) NSString *notificationName;
@property (nonatomic,weak) id object;

- (instancetype)initWithObserver:(id)observer selector:(SEL)selector notificationName:(NSString*)notiName object:(id)object;

@end

@implementation NotificationObserver

- (instancetype)initWithObserver:(id)observer selector:(SEL)selector notificationName:(NSString*)notiName object:(id)object
{
    self = [super init];
    if(self){
        self.observer = observer;
        self.selector = selector;
        self.notificationName = notiName;
        self.object = object;
    }
    return self;
}

@end

/**
 
 NotificationCenter
 
 */

@interface MXNotificationCenter()
{
    NSMutableArray *list;
    NSLock *lock;
}

@end

@implementation MXNotificationCenter

+ (MXNotificationCenter *)defaultCenter
{
    static MXNotificationCenter* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        lock = [NSLock new];
    }
    return self;
}

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
    if(!observer || !aSelector || !aName.length){
        return;
    }
    if([observer respondsToSelector:aSelector] == NO){
        //NSLog(@"%s: %@ 没有 %@ 方法", __func__, NSStringFromClass([observer class]), NSStringFromSelector(aSelector));
        return;
    }
    if(!list){
        list = [NSMutableArray array];
    }
    if(list.count){
        //判断是否存在一个一模一样的观察者
        BOOL needReturn = NO;
        [lock lock];
        for(NotificationObserver *object in list){
            if(object.observer == observer && object.selector==aSelector && [object.notificationName isEqualToString:aName] && object.object == anObject){
                needReturn = YES;
                break;
            }
        }
        [lock unlock];
        if(needReturn){
            return;
        }
    }
    NotificationObserver *observerObject = [[NotificationObserver alloc] initWithObserver:observer selector:aSelector notificationName:aName object:anObject];
    [lock lock];
    [list addObject:observerObject];
    [lock unlock];
}

- (void)postNotification:(MXNotification *)notification
{
    if(!notification || !notification.name.length){
        return;
    }
    if(!list.count){
        return;
    }
    [lock lock];
    for(NotificationObserver *observerObject in list){
        if(observerObject.observer && [notification.name isEqualToString:observerObject.notificationName]){
            [observerObject.observer performSelector:observerObject.selector withObject:notification];
            //objc_msgSend(observerObject.observer, observerObject.selector, notification);
        }
    }
    [lock unlock];
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject
{
    MXNotification *notification = [[MXNotification alloc] initWithName:aName object:anObject userInfo:nil];
    [self postNotification:notification];
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
    MXNotification *notification = [[MXNotification alloc] initWithName:aName object:anObject userInfo:aUserInfo];
    [self postNotification:notification];
}

@end
