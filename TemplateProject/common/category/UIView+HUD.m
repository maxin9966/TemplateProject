//
//  UIView+HUD.m
//  FansKit
//
//  Created by antsmen on 15-1-7.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "UIView+HUD.h"
#import <objc/runtime.h>

static const void *hudLoadingTipsKey = &hudLoadingTipsKey;
static const void *hudTipsKey = &hudTipsKey;
static const void *hudDoneTipsKey = &hudDoneTipsKey;
static const void *hudErrorTipsKey = &hudErrorTipsKey;

@implementation UIView (HUD)

- (MBProgressHUD *)loadingView
{
    return objc_getAssociatedObject(self, hudLoadingTipsKey);
}

- (void)setLoadingView:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, hudLoadingTipsKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)tipsView
{
    return objc_getAssociatedObject(self, hudTipsKey);
}

- (void)setTipsView:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, hudTipsKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)doneTipsView
{
    return objc_getAssociatedObject(self, hudDoneTipsKey);
}

- (void)setDoneTipsView:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, hudDoneTipsKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)errorTipsView
{
    return objc_getAssociatedObject(self, hudErrorTipsKey);
}

- (void)setErrorTipsView:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, hudErrorTipsKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 普通提示
- (void)showTips:(NSString*)text
{
    [self showTips:text duration:1.f touchEnabled:NO completionBlock:nil];
}

- (void)showTips:(NSString*)text touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion
{
    [self showTips:text duration:1.f touchEnabled:touchEnabled completionBlock:completion];
}

- (void)showTips:(NSString*)text duration:(NSTimeInterval)interval touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion
{
    MBProgressHUD *tipView = [self tipsView];
    if(!tipView){
        tipView = [[MBProgressHUD alloc] initWithView:self];
        tipView.customView = [[UIImageView alloc] initWithImage:nil];
        tipView.mode = MBProgressHUDModeCustomView;
        [self setTipsView:tipView];
    }else{
        [tipView hide:NO];
    }
    if(!tipView.superview){
        [self addSubview:tipView];
    }
    tipView.userInteractionEnabled = !touchEnabled;
    tipView.detailsLabelText = text;
    [tipView show:YES completionBlock:completion];
    [tipView hide:YES afterDelay:interval];
}

- (void)hideTips
{
    MBProgressHUD *tipView = [self tipsView];
    if(tipView){
        [tipView hide:YES];
    }
}

#pragma mark - 操作完成
- (void)showDoneTips:(NSString*)text
{
    [self showDoneTips:text duration:1.f touchEnabled:NO completionBlock:nil];
}

- (void)showDoneTips:(NSString*)text touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion
{
    [self showDoneTips:text duration:1.f touchEnabled:touchEnabled completionBlock:completion];
}

- (void)showDoneTips:(NSString*)text duration:(NSTimeInterval)interval touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion
{
    MBProgressHUD *tipView = [self doneTipsView];
    if(!tipView){
        tipView = [[MBProgressHUD alloc] initWithView:self];
        tipView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud-done"]];
        tipView.mode = MBProgressHUDModeCustomView;
        [self setDoneTipsView:tipView];
    }else{
        [tipView hide:NO];
    }
    if(!tipView.superview){
        [self addSubview:tipView];
    }
    tipView.userInteractionEnabled = !touchEnabled;
    tipView.detailsLabelText = text;
    [tipView show:YES completionBlock:completion];
    [tipView hide:YES afterDelay:interval];
}

- (void)hideDoneTips
{
    MBProgressHUD *tipView = [self doneTipsView];
    if(tipView){
        [tipView hide:YES];
    }
}

#pragma mark - 错误提示
- (void)showErrorTips:(NSString*)text
{
    [self showErrorTips:text duration:1.f touchEnabled:NO completionBlock:nil];
}

- (void)showErrorTips:(NSString*)text touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion
{
    [self showErrorTips:text duration:1.f touchEnabled:touchEnabled completionBlock:completion];
}

- (void)showErrorTips:(NSString*)text duration:(NSTimeInterval)interval touchEnabled:(BOOL)touchEnabled completionBlock:(MBProgressHUDCompletionBlock)completion
{
    MBProgressHUD *tipView = [self errorTipsView];
    if(!tipView){
        tipView = [[MBProgressHUD alloc] initWithView:self];
        tipView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud-warn"]];
        tipView.mode = MBProgressHUDModeCustomView;
        [self setErrorTipsView:tipView];
    }else{
        [tipView hide:NO];
    }
    if(!tipView.superview){
        [self addSubview:tipView];
    }
    tipView.userInteractionEnabled = !touchEnabled;
    tipView.detailsLabelText = text;
    [tipView show:YES completionBlock:completion];
    [tipView hide:YES afterDelay:interval];
}

- (void)hideErrorTips
{
    MBProgressHUD *tipView = [self errorTipsView];
    if(tipView){
        [tipView hide:YES];
    }
}

#pragma mark - 正在加载
- (void)showLoadingTips:(NSString*)text
{
    [self showLoadingTips:text touchEnabled:NO];
}

- (void)showLoadingTips:(NSString*)text touchEnabled:(BOOL)touchEnabled
{
    MBProgressHUD *loadingView = [self loadingView];
    if(!loadingView){
        loadingView = [[MBProgressHUD alloc] initWithView:self];
        loadingView.minShowTime = 0.2;
        [self setLoadingView:loadingView];
    }
    if(!loadingView.superview){
        [self addSubview:loadingView];
    }
    loadingView.detailsLabelText = text;
    loadingView.userInteractionEnabled = !touchEnabled;
    [loadingView show:YES];
}

- (void)hideLoadingTips
{
    MBProgressHUD *loadingView = [self loadingView];
    if(loadingView){
        [loadingView hide:NO];
    }
}

#pragma mark - 
- (void)hideAllHUD
{
    [MBProgressHUD hideAllHUDsForView:self animated:NO];
}

@end
