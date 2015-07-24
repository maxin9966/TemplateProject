//
//  TestViewController.m
//  TemplateProject
//
//  Created by admin on 15/7/24.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [MXDefaultNotificationCenter addObserver:self selector:@selector(receivedMXNotification:) name:TestNotification object:nil];
    
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgBtn];
    bgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [bgBtn addTarget:self action:@selector(postMXNotification) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postMXNotification
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [MXDefaultNotificationCenter postNotificationName:TestNotification object:@"约吗？"];
    });
}

- (void)receivedMXNotification:(MXNotification*)notification
{
    NSLog(@"%@ received a MXNotificaion:%@\nThread:%d",NSStringFromClass([self class]),notification.object,[NSThread currentThread].isMainThread);
}

@end
