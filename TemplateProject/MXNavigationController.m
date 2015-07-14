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
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    completionArray = [NSMutableArray array];
    //self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
