//
//  MXNavigationController.m
//  LaneTrip
//
//  Created by antsmen on 15-4-14.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MXNavigationController.h"
#import "BlockAlertView.h"

@interface MXNavigationController ()
<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *completionArray;
    BOOL isLogin;
}

@end

@implementation MXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self setInteractivePopGestureRecognizer];
        //解决button某些事件不触发的问题
        self.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
    }
    completionArray = [NSMutableArray array];
    self.delegate = self;//bug ???
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInteractivePopGestureRecognizer
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // fix 'nested pop animation can result in corrupted navigation bar'
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
    [super pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(PushCompletionBlock)completion
{
    NSDictionary *dict = @{@"viewController":viewController,@"completion":completion};
    [completionArray addObject:dict];
    [self pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
//        navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
    for(NSDictionary *dict in completionArray){
        if([dict objectForKeySafely:@"viewController"] == viewController){
            PushCompletionBlock block = [dict objectForKeySafely:@"completion"];
            if(block){
                block();
            }
            [completionArray removeObject:dict];
            break;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if(gestureRecognizer == self.interactivePopGestureRecognizer){
            //[[UIApplication sharedApplication].keyWindow endEditing:YES];
            [DefaultNotificationCenter postNotificationName:NotiNavigationPopGestureWillBegin object:nil userInfo:nil];
        }
    }
    return YES;
}

@end
