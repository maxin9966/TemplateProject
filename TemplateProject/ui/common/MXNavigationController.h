//
//  MXNavigationController.h
//  LaneTrip
//
//  Created by antsmen on 15-4-14.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NotiNavigationPopGestureWillBegin @"NotiNavigationPopGestureWillBegin"

typedef void(^PushCompletionBlock)();

@interface MXNavigationController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(PushCompletionBlock)completion;

- (void)setInteractivePopGestureRecognizer;

@end
