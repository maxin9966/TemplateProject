//
//  MyCommon.m
//  FansKit
//
//  Created by MA on 14/12/1.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "MyCommon.h"

@implementation MyCommon

//音频管理器
+ (PUAudioManager*)audioManager
{
    static PUAudioManager *puAudioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        puAudioManager = [[PUAudioManager alloc] initWithNamespace:@"PUAudioCache"];
    });
    return puAudioManager;
}

//save userDefault
+ (BOOL)saveDataToUserDefault:(id)data WithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:key];
    return [defaults synchronize];
}

//get userDefault
+ (id)getDataFromUserDefaultWithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id object = [defaults objectForKey:key];
    return object;
}

//remove userDefault
+ (BOOL)removeDataFromUserDefaultWithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    return [defaults synchronize];
}

//电话正则
+ (BOOL)isMobile:(NSString *)mobileNumber
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|8[0-9])\\d{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL isPhone = [mobileTest evaluateWithObject:mobileNumber];
    if (isPhone) {
        return YES;
    }
    return NO;
}

//邮箱匹配
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex =  @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    NSPredicate *emailTest = [ NSPredicate predicateWithFormat : @"SELF MATCHES%@",emailRegex];
    BOOL isMail = [emailTest evaluateWithObject:email];
    if (isMail) {
        return YES;
    }
    return NO;
}

//获取uuid
+ (NSString *)createUUID{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    result =[NSString stringWithFormat:@"%@", uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
}

//获取纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//关闭键盘
+ (void)closeKeyboard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

//获取normal level window
+ (UIWindow*)normalLevelWindow
{
    NSInteger windowCount = [UIApplication sharedApplication].windows.count;
    for(NSInteger i=windowCount-1;i>=0;i--){
        UIWindow *w = [[UIApplication sharedApplication].windows objectAtIndex:i];
        if(w.windowLevel==UIWindowLevelNormal){
            return w;
        }
    }
    return nil;
}

//动画类型
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            
        default:
            return kNilOptions;
    }
}

//显示提示框
+(UIAlertView*)showTips:(NSString*)string
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    return alert;
}

//显示提示框 一定时间内不再提示 interval传0则表示永不重复
+ (UIAlertView*)showTips:(NSString *)string key:(NSString*)key noRepeatInterval:(NSTimeInterval)interval
{
    if(!key.length){
        return nil;
    }
    NSDate *date = [MyCommon getDataFromUserDefaultWithKey:key];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval elapsedTime = [nowDate timeIntervalSinceDate:date];
    if(interval){
        if(!date || elapsedTime>=interval){
            [MyCommon saveDataToUserDefault:nowDate WithKey:key];
            return [MyCommon showTips:string];
        }
    }else{
        //显示一次之后永不提示
        if(!date){
            [MyCommon saveDataToUserDefault:nowDate WithKey:key];
            return [MyCommon showTips:string];
        }
    }
    return nil;
}

//执行某些代码 一定时间内不重复 interval传0则表示永不重复
+ (void)executing:(dispatch_block_t)block key:(NSString*)key noRepeatInterval:(NSTimeInterval)interval
{
    if(!block || !key.length){
        return;
    }
    NSDate *date = [MyCommon getDataFromUserDefaultWithKey:key];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval elapsedTime = [nowDate timeIntervalSinceDate:date];
    if(interval){
        if(!date || elapsedTime>=interval){
            [MyCommon saveDataToUserDefault:nowDate WithKey:key];
            block();
        }
    }else{
        //显示一次之后永不提示
        if(!date){
            [MyCommon saveDataToUserDefault:nowDate WithKey:key];
            block();
        }
    }
}

@end
