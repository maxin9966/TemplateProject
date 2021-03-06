//
//  BaseViewController.m
//  LaneTrip
//
//  Created by antsmen on 15-4-28.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    BOOL needRefresh;
    BOOL isShowing;
    BOOL isPop;
}

@end

@implementation BaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiDidLogin object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:NotiDidLogin object:nil];
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setFd_prefersNavigationBarHidden:YES];
    [self setFd_interactivePopDisabled:NO];
}

- (void)didLogin
{
    if(!isShowing){
        needRefresh = YES;
        return;
    }
    [self refreshAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isShowing = YES;
    if(needRefresh){
        [self refreshAction];
        needRefresh = NO;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        //pushed
        isPop = NO;
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        //popped
        isPop = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    isShowing = NO;
    if(isPop){
        [self viewDidBack];
        isPop = NO;
    }
}

#pragma mark - abstract method

- (void)viewDidBack
{
    
}

- (void)refreshAction
{
    
}

@end
