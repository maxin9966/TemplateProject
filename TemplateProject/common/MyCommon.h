//
//  MyCommon.h
//  FansKit
//
//  Created by MA on 14/12/1.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLoader.h"
#import "PUFileManager.h"
#import "UIView+HUD.h"
#import "MyTimer.h"
#import "PUImageManager.h"
#import "UIImageView+Cache.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Utility.h"

/**
 
 common
 
 */


/**
 
 宏定义
 
 */

//屏蔽NSLog
//#ifndef __OPTIMIZE__
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...) {}
//#endif

//获取系统版本号
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//屏幕宽高
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE  [UIScreen mainScreen].scale
//RGBA
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
//角度
#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)
//是否为iPhone4
#define isIphone4 (SCREEN_HEIGHT==480)
//项目版本号
#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

@interface MyCommon : NSObject

//文件管理器
+ (PUFileManager*)fileManger;

//音频管理器
+ (PUFileManager*)audioManager;

//图片管理器
+ (PUImageManager*)imageManager;

//save userDefault
+ (BOOL)saveDataToUserDefault:(id)data WithKey:(NSString *)key;

//get userDefault
+ (id)getDataFromUserDefaultWithKey:(NSString *)key;

//remove userDefault
+ (BOOL)removeDataFromUserDefaultWithKey:(NSString *)key;

//电话正则匹配
+ (BOOL)isMobile:(NSString *)mobileNumber;

//邮箱正则匹配
+ (BOOL)isEmail:(NSString *)email;

//获取一个新的UUID
+ (NSString *)createUUID;

//获取纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//关闭键盘
+ (void)closeKeyboard;

//获取normal level window
+ (UIWindow*)normalLevelWindow;

//动画类型
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;

//显示提示框
+ (UIAlertView*)showTips:(NSString*)string;

//显示提示框 一定时间内不再提示 interval传0则表示永不重复
+ (UIAlertView*)showTips:(NSString *)string key:(NSString*)key noRepeatInterval:(NSTimeInterval)interval;

//执行某些代码 一定时间内不重复 interval传0则表示永不重复
+ (void)executing:(dispatch_block_t)block key:(NSString*)key noRepeatInterval:(NSTimeInterval)interval;

@end
