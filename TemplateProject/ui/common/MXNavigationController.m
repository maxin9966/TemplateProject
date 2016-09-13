//
//  MXNavigationController.m
//  LaneTrip
//
//  Created by antsmen on 15-4-14.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MXNavigationController.h"

@interface MXNavigationController ()
<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation MXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
////        self.interactivePopGestureRecognizer.delegate = nil;
//        //解决button某些事件不触发的问题
//        self.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
//    }
//    self.delegate = self;//bug ???
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
