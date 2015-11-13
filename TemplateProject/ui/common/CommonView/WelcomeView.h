//
//  WelcomeView.h
//  FansKit
//
//  Created by MA on 14/12/18.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 
 欢迎页
 
 */

extern NSString *const kWelcomeDidDismissEvent;

@interface WelcomeView : UIView

+ (void)showWithFileName:(NSString*)fileName;

+ (void)dismiss;

@end
