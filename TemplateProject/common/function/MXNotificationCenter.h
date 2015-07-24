//
//  MXNotificationCenter.h
//  TemplateProject
//
//  Created by admin on 15/7/24.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MXDefaultNotificationCenter [MXNotificationCenter defaultCenter]

@interface MXNotification : NSObject

@property (readonly, copy) NSString *name;
@property (readonly, strong) id object;
@property (readonly, copy) NSDictionary *userInfo;

- (instancetype)initWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;

@end

@interface MXNotificationCenter : NSObject

+ (MXNotificationCenter *)defaultCenter;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;

- (void)postNotification:(MXNotification *)notification;
- (void)postNotificationName:(NSString *)aName object:(id)anObject;
- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

@end
