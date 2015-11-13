//
//  UIViewController+NavigationBar.h
//  LaneTrip
//
//  Created by antsmen on 15-4-15.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)

- (UIView*)navigationBar;

- (UIImageView*)backgroundImageView;

- (UILabel*)titleLabel;

- (UIButton*)leftButton;

- (UIButton*)rightButton;


- (void)installNavigationBar;

- (void)installCustomNavigationBar;

- (void)installBackButton;

- (void)installBackButtonWithSelection:(SEL)selection;

- (void)setNavigationTitle:(NSString *)title;

- (void)setLeftButtonWithTitle:(NSString *)title selector:(SEL)selector;

- (void)setRightButtonWithTitle:(NSString *)title selector:(SEL)selector;

- (void)setLeftButtonWithSelector:(SEL)selector normalImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage;

- (void)setRightButtonWithSelector:(SEL)selector normalImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage;

- (void)removeNavigationBar;

@end
