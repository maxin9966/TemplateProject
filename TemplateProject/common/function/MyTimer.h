//
//  TimerCode.h
//  TimerCode
//
//  Created by ma on 13-12-14.
//  Copyright (c) 2013年 ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTimer : NSObject

+ (MyTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)aUserInfo repeats:(BOOL)isRepeat;

- (void)invalidate;

@end
