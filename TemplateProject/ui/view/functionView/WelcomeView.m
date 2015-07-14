//
//  WelcomeView.m
//  FansKit
//
//  Created by MA on 14/12/18.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "WelcomeView.h"

NSString *const kWelcomeDidDismissEvent = @"kWelcomeDidDismissEvent";

static WelcomeView *welcomeView = nil;

@interface WelcomeView()
<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    NSMutableArray *list;
    int nowIndex;
    UIPageControl *control;
    UIAlertView *alert;
}

@end

@implementation WelcomeView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        [self addSubview:scrollView];
        control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 10)];
        [self addSubview:control];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap
{
    if(nowIndex == list.count-1){
        [self remove];
    }
}

- (void)loadWithFileName:(NSString*)fileName
{
    [self reset];
    if(!list){
        list = [NSMutableArray array];
    }
    //从硬盘检测有多少张图片
    for(int i=1;;i++){
        NSString *fn;
        fn = [NSString stringWithFormat:@"%@%d",fileName,i];
        NSString *path = [[NSBundle mainBundle] pathForResource:fn ofType:@"jpg"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
            [list addObject:fn];
        }else{
            break;
        }
    }
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    scrollView.contentSize = CGSizeMake(list.count*width, 0);
    for(int i=0;i<list.count;i++){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *fn = [list objectAtIndex:i];
        imgView.image = [UIImage imageNamed:[fn stringByAppendingString:@".jpg"]];
        [scrollView addSubview:imgView];
    }
    control.numberOfPages = list.count;
    control.currentPage = 0;
}

- (void)reset
{
    [list removeAllObjects];
    for(UIView *view in scrollView.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view removeFromSuperview];
        }
    }
}

+ (void)showWithFileName:(NSString*)fileName
{
    if(!welcomeView){
        welcomeView = [[WelcomeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    [welcomeView loadWithFileName:fileName];
    UIWindow *window = [MyCommon normalLevelWindow];
    [window addSubview:welcomeView];
}

+ (void)dismiss
{
    if(welcomeView){
        [welcomeView remove];
    }
}

- (void)remove
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        self.userInteractionEnabled = YES;
        [self removeFromSuperview];
        [self reset];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWelcomeDidDismissEvent object:nil];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    CGFloat offsetX = _scrollView.contentOffset.x;
    CGFloat width = _scrollView.frame.size.width;
    nowIndex = offsetX/width+0.5;
    control.currentPage = nowIndex;
}

@end
