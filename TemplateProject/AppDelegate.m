//
//  AppDelegate.m
//  TemplateProject
//
//  Created by antsmen on 15-3-17.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "UserLocation.h"
#import "UncaughtExceptionHandler.h"
#import "TouchDetector.h"
#import <FIR/FIR.h>
#import "WelcomeView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize viewController;
@synthesize navigationVC;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //首次打开
    [self firstOpen];
    
    //初始化界面
    viewController = [[MainViewController alloc] init];
    navigationVC = [[MXNavigationController alloc] initWithRootViewController:viewController];
    navigationVC.navigationBarHidden = YES;
    [navigationVC.navigationBar setBgColor:navigationBarBgColor];
    navigationVC.navigationBar.tintColor = navigationBarTitleColor;
    [navigationVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : navigationBarTitleColor}];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navigationVC;
    [self.window makeKeyAndVisible];
    
    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //crash日志
    //InstallUncaughtExceptionHandler();
    
    //bug日志
    [FIR handleCrashWithKey:@"YOUR FIR KEY"];
    
    //检测触摸事件
    [TouchDetector install];
    
    //初始化
    [self initialization];
    
    return YES;
}

//初始化
- (void)initialization
{
    if(![MyCommon getDataFromUserDefaultWithKey:kUDFirstOpenTime]){
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        [MyCommon saveDataToUserDefault:@(time) WithKey:kUDFirstOpenTime];
    }
    //欢迎页
//    if(![MyCommon getDataFromUserDefaultWithKey:kUDBoolWelcome]){
//        [WelcomeView showWithFileName:@"welcome"];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(welcomeViewDidDismiss) name:kWelcomeDidDismissEvent object:nil];
//    }
}

- (void)welcomeViewDidDismiss
{
    [MyCommon saveDataToUserDefault:@(YES) WithKey:kUDBoolWelcome];
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

//首次打开
- (void)firstOpen
{
    if(![MyCommon getDataFromUserDefaultWithKey:kUDFirstOpenTime]){
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        [MyCommon saveDataToUserDefault:@(time) WithKey:kUDFirstOpenTime];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //停止坐标更新
    [[UserLocation sharedInstance] stopUpdate];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //坐标更新
    [[UserLocation sharedInstance] startUpdate];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
