//
//  WelcomeGifView.m
//  YanMo
//
//  Created by admin on 16/3/24.
//  Copyright © 2016年 antsmen. All rights reserved.
//

#import "WelcomeGifView.h"
#import "YLGIFImage.h"
#import "YLImageView.h"

static WelcomeGifView *welcomeView = nil;

@interface WelcomeGifView ()

@property (nonatomic,strong) YLImageView *imageView;

@property (nonatomic,copy) CommonBlock completion;

@end

@implementation WelcomeGifView

- (id)initWithFrame:(CGRect)frame gifName:(NSString*)gifName
{
    self = [super initWithFrame:frame];
    if(self){
        __weak typeof(self)wSelf = self;
        
        _imageView = [[YLImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        _imageView.completion = ^(){
            [wSelf remove];
        };
        
        YLGIFImage *img = (YLGIFImage*)[YLGIFImage imageNamed:gifName];
        img.loopCount = 1;
        _imageView.image = img;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

+ (void)showWithGifName:(NSString*)gifName completion:(CommonBlock)completion
{
    if(!welcomeView){
        welcomeView = [[WelcomeGifView alloc] initWithFrame:[UIScreen mainScreen].bounds gifName:gifName];
    }
    welcomeView.completion = completion;
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
        if(self.completion){
            self.completion();
        }
    }];
}

- (void)reset
{
    
}

@end
