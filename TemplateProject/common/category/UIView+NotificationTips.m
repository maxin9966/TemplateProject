//
//  UIView+NotificationTips.m
//  YanMo
//
//  Created by 马鑫 on 15/12/6.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "UIView+NotificationTips.h"
#import <objc/runtime.h>

static const void *notificationTipsKey = &notificationTipsKey;

@implementation UIView (NotificationTips)

- (UIImageView *)notificationTipsView
{
    return objc_getAssociatedObject(self, notificationTipsKey);
}

- (void)showNotificationTipsInCenter:(CGPoint)point
{
    UIImageView *imgView = [self notificationTipsView];
    if(!imgView){
        imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-tip"]];
        imgView.frame = CGRectMake(0, 0, 10, 10);
        objc_setAssociatedObject(self, notificationTipsKey, imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    imgView.center = point;
    [self addSubview:imgView];
}

- (void)hideNotificationTips
{
    [[self notificationTipsView] removeFromSuperview];
}

@end
