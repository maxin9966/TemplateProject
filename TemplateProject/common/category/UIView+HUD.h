//
//  UIView+HUD.h
//  FansKit
//
//  Created by antsmen on 15-1-7.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (HUD)

//普通提示
- (void)showTips:(NSString*)text;
- (void)showTips:(NSString*)text touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)showTips:(NSString*)text duration:(NSTimeInterval)interval touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)hideTips; //立刻关闭

//操作完成提示
- (void)showDoneTips:(NSString*)text;
- (void)showDoneTips:(NSString*)text touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)showDoneTips:(NSString*)text duration:(NSTimeInterval)interval touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)hideDoneTips; //立刻关闭

//错误提示
- (void)showErrorTips:(NSString*)text;
- (void)showErrorTips:(NSString*)text touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)showErrorTips:(NSString*)text duration:(NSTimeInterval)interval touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)hideErrorTips; //立刻关闭

//正在加载
- (void)showLoadingTips:(NSString*)text;
- (void)showLoadingTips:(NSString*)text touchEnabled:(BOOL)touchEnabled;
- (void)hideLoadingTips;

//移除所有提示
- (void)hideAllHUD;

@end
