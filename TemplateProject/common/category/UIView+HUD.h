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
- (void)showTips:(NSString*)text touchEnabled:(BOOL)touchEnabled;
- (void)showTips:(NSString*)text duration:(NSTimeInterval)interval touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)hideTips; //立刻关闭

//操作完成
- (void)showDoneTips:(NSString*)text;
- (void)showDoneTips:(NSString*)text duration:(NSTimeInterval)interval touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)hideDoneTips; //立刻关闭

//正在加载
- (void)showLoadingTips:(NSString*)text;
- (void)hideLoadingTips;

//移除所有提示
- (void)hideAllHUD;

@end
