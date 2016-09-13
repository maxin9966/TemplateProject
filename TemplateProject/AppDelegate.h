//
//  AppDelegate.h
//  TemplateProject
//
//  Created by antsmen on 15-3-17.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class MXNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) ViewController *viewController;

@property (nonatomic,strong) MXNavigationController *navigationVC;

@end

