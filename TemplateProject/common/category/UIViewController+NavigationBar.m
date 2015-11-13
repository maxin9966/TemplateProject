//
//  UIViewController+NavigationBar.m
//  LaneTrip
//
//  Created by antsmen on 15-4-15.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import <objc/runtime.h>

static const void *navigationBarKey = &navigationBarKey;
static const void *navigationBarLeftButtonKey = &navigationBarLeftButtonKey;
static const void *navigationBarRightButtonKey = &navigationBarRightButtonKey;
static const void *navigationBarTitleLabelKey = &navigationBarTitleLabelKey;
static const void *navigationBarBackgroundImageViewKey = &navigationBarBackgroundImageViewKey;

//参数
static const CGFloat navigationButtonWidth = 50.f;

@implementation UIViewController (NavigationBar)

- (UIView*)navigationBar
{
    return objc_getAssociatedObject(self, navigationBarKey);
}

- (void)installNavigationBar
{
    if(![self navigationBar]){
        UIView *navigationBar = [[UIView alloc] init];
        navigationBar.backgroundColor = LT_NavigationBarBgColor;
        [self.view addSubview:navigationBar];
        
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.contentMode = UIViewContentModeScaleToFill;
        bgImageView.image = [UIImage imageNamed:@"tab_bg"];
        [navigationBar addSubview:bgImageView];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitleColor:LT_NavigationBarTitleColor forState:UIControlStateNormal];
        [leftBtn.titleLabel setFont:LT_NavigationBarTitleFont];
        [navigationBar addSubview:leftBtn];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitleColor:LT_NavigationBarTitleColor forState:UIControlStateNormal];
        [rightBtn.titleLabel setFont:LT_NavigationBarTitleFont];
        [navigationBar addSubview:rightBtn];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = LT_NavigationBarTitleFont;
        titleLabel.textColor = LT_NavigationBarTitleColor;
        [navigationBar addSubview:titleLabel];
        
        objc_setAssociatedObject(self, navigationBarLeftButtonKey, leftBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, navigationBarRightButtonKey, rightBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, navigationBarKey, navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, navigationBarTitleLabelKey, titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, navigationBarBackgroundImageViewKey, bgImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [RACObserve(self.view, frame) subscribeNext:^(id object) {
            [self updateFrame];
        }];
    }
}

- (UIButton*)leftButton
{
    return objc_getAssociatedObject(self, navigationBarLeftButtonKey);
}

- (UIButton*)rightButton
{
    return objc_getAssociatedObject(self, navigationBarRightButtonKey);
}

- (UILabel*)titleLabel
{
    return objc_getAssociatedObject(self, navigationBarTitleLabelKey);
}

- (UIImageView*)backgroundImageView
{
    return objc_getAssociatedObject(self, navigationBarBackgroundImageViewKey);
}

- (void)updateFrame
{
    CGFloat statusBarHeight = 20;
    [self navigationBar].frame = CGRectMake(0, 0, SCREEN_WIDTH, 44+statusBarHeight);
    [self leftButton].frame = CGRectMake(8, statusBarHeight, navigationButtonWidth, [self navigationBar].frame.size.height-statusBarHeight);
    [self rightButton].frame = CGRectMake([self navigationBar].frame.size.width-navigationButtonWidth-8, statusBarHeight, navigationButtonWidth, [self navigationBar].frame.size.height-statusBarHeight);
    CGFloat leftOriginX = [self leftButton].frame.origin.x+[self leftButton].frame.size.width+5;
    CGFloat rightOriginX = [self rightButton].frame.origin.x-5;
    [self titleLabel].frame = CGRectMake(leftOriginX, statusBarHeight, rightOriginX-leftOriginX, [self navigationBar].frame.size.height-statusBarHeight);
    CGRect bgRect = [self navigationBar].bounds;
//    bgRect.origin.y = statusBarHeight;//???
//    bgRect.size.height = 59;
    [self backgroundImageView].frame = bgRect;
}

- (void)setNavigationTitle:(NSString *)title
{
    [self titleLabel].text = title;
}

- (void)setLeftButtonWithTitle:(NSString *)title selector:(SEL)selector
{
    UIButton *button = [self leftButton];
    [self clearBtn:button];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setRightButtonWithTitle:(NSString *)title selector:(SEL)selector
{
    UIButton *button = [self rightButton];
    [self clearBtn:button];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setLeftButtonWithSelector:(SEL)selector normalImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage
{
    UIButton *button = [self leftButton];
    [self clearBtn:button];
    [button setImage:normalImage forState:UIControlStateNormal];
    if(highlightImage){
        [button setImage:highlightImage forState:UIControlStateHighlighted];
    }
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setRightButtonWithSelector:(SEL)selector normalImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage
{
    UIButton *button = [self rightButton];
    [self clearBtn:button];
    [button setImage:normalImage forState:UIControlStateNormal];
    if(highlightImage){
        [button setImage:highlightImage forState:UIControlStateHighlighted];
    }
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)installBackButton
{
    [self setLeftButtonWithSelector:@selector(back) normalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back-white"]];
}

- (void)installBackButtonWithSelection:(SEL)selection
{
    [self setLeftButtonWithSelector:selection normalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back-white"]];
}

- (void)setBackgroundImage:(UIImage*)bgImage
{
    [self backgroundImageView].image = bgImage;
}

#pragma mark - back
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
- (void)removeNavigationBar
{
    [[self navigationBar] removeFromSuperview];
}

- (void)clearBtn:(UIButton*)btn
{
    [btn setTitle:nil forState:UIControlStateNormal];
    [btn setImage:nil forState:UIControlStateNormal];
    [btn setImage:nil forState:UIControlStateHighlighted];
    [btn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
}

@end
