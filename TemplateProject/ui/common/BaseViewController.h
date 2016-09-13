//
//  BaseViewController.h
//  LaneTrip
//
//  Created by antsmen on 15-4-28.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BaseViewController : UIViewController

//刷新操作方法
- (void)refreshAction;

//返回通知方法
- (void)viewDidBack;

@end
