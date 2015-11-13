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
#import "UINavigationBar+Utility.h"
#import "NSDictionary+Utility.h"
#import "NSCoder+Utility.h"
#import "Reachability.h"
#import "UIViewController+NavigationBar.h"
#import "UIView+Utility.h"
#import "NSArray+Utility.h"
#import "UIScrollView+Category.h"
#import "NSDate+Category.h"
#import "MXNavigationController.h"
#import "NSString+Utility.h"
#import "BlockAlertView.h"
#import "NSObject+Utility.h"
#import "NoCoverView.h"
#import "SVPullToRefresh.h"
#import "AppDelegate.h"
#import "MXNotificationCenter.h"
#import "NSTimer+Block.h"
#import "UIResponder+Router.h"
#import "NSURL+Utility.h"
#import "UIViewController+DismissKeyboard.h"

/**
 
 common
 
 */


/**
 
 宏定义
 
 */

//屏蔽NSLog
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

//获取系统版本号
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//屏幕宽高
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE  [UIScreen mainScreen].scale
//屏幕比例
#define SCREEN_5_INCH_RATIO (SCREEN_WIDTH /320.f)
#define SCREEN_6_INCH_RATIO (SCREEN_WIDTH /375.f)
//RGBA
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
//角度
#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)
//是否为iPhone4
#define isIphone4 (SCREEN_HEIGHT==480)
#define isIphone5 (SCREEN_WIDTH==320)
//项目版本号
#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//字体
#define FONT(s)  [UIFont boldSystemFontOfSize:s]
//判断是否是模拟器
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR YES
#elif TARGET_OS_IPHONE
#define SIMULATOR NO
#endif
//常用
#define DefaultNotificationCenter [NSNotificationCenter defaultCenter]

@interface MyCommon : NSObject

/**
 
 barButton
 
 */
+ (NSArray *)backBarButtonItemWithTarget:(id)target withSelector:(SEL)selector;
+ (NSArray *)doneBarButtonItemWithTarget:(id)target withSelector:(SEL)selector;
+ (NSArray *)customBarButtonItemWithTarget:(id)target withSelector:(SEL)selector withBtnImage:(NSString *)image withBtnHighlightImage:(NSString *)highlightImage;
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString*)title target:(id)target withSelector:(SEL)selector;

//文件管理器
+ (PUFileManager*)fileManger;

//音频管理器
+ (PUFileManager*)audioManager;

//图片管理器
+ (PUImageManager*)imageManager;

//获取缓存大小
+ (NSUInteger)getDiskCacheSize;

//清除硬盘缓存
+ (void)clearDiskCache;

//内存占用 字节
+ (int)availableMemory;

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

//视频转MP4 (截取10秒)
+ (void)encodeVideoByUrl:(NSURL*)_videoURL ToUrl:(NSURL*)_mp4URL Quality:(NSString *const)quality Completion:(void (^)(BOOL isSuccess))completion;

//PCM转MP3
+ (void)audio_PCMtoMP3_WavPath:(NSString*)pcmFilePath MP3Path:(NSString*)mp3FilePath;

//获取失败error
+ (NSError *)getErrorWithFailureReason:(NSString*)reason;

//获取错误信息
+ (NSError*)getErrorWithResponse:(NSDictionary*)dict;

//获取请求失败的error
+ (NSError*)getFailureError:(NSError*)originError;

//检测网络通畅
+ (BOOL)isEnableNetwork;

//检测网络类型
+ (NetworkStatus)getNetworkType;

//放大动画
+(void)zoomAnimation:(UIView*)view completion:(void (^)(BOOL finished))completion;

//头像图片压缩
+ (UIImage*)avatarCompression:(UIImage*)avatarImg;

//校爆图片降低分辨率
+ (UIImage*)reduceResolution:(UIImage*)image;

//用户相片图片压缩
+ (UIImage*)photoCompress:(UIImage*)image;

//随机获取的图片地址
+ (NSURL*)getRandomImageURL;

//label size to fit
+ (void)sizeToFitWithLabel:(UILabel*)label;

+ (void)widthToFitWithLabel:(UILabel*)label;

+ (void)widthToFitWithLabel:(UILabel*)label widthLimmit:(CGFloat)limmit;

//字节
+ (NSString *)readableValueWithBytes:(id)bytes;

//解析URL参数
+ (NSDictionary*)parseURLParams:(NSString *)query;

//根据时间戳获取date
+ (NSDate*)dateWithTimeIntervalSince1970:(NSTimeInterval)interval;

//根据date获取时间戳
+ (NSTimeInterval)timeIntervalWithDate:(NSDate*)date;

//屏幕截图
+ (UIImage*)getScreenImageAfterScreenUpdates:(BOOL)afterScreenUpdates;

//获取文件字符串数据
+ (NSString*)stringWithFileName:(NSString*)fileName ofType:(NSString*)fileType encoding:(NSStringEncoding)encoding;

+ (AppDelegate*)appDelegate;

+ (NSString *)notRounding:(float)price afterPoint:(NSInteger)position;

@end
