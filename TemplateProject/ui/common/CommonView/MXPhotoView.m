//
//  MXPhotoView.m
//  FansKit
//
//  Created by MA on 14/12/18.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "MXPhotoView.h"
#import <QuartzCore/QuartzCore.h>

#define ImageMaxScale 4         //最大放大倍数
#define ImageMinScale 1.7       //最小放大倍数

static MXPhotoView *mxPhotoView = nil;

@interface MXPhotoView ()
{
    UIImageView *_imageView;
    CGRect scaleOriginRect;
    BOOL isShowing;
}
@property (nonatomic,assign) BOOL showStatusBarWhenDismiss;

@end

@implementation MXPhotoView
@synthesize image;
@synthesize showStatusBarWhenDismiss;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
                
        // 图片
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        // 属性
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:singleTap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

- (UIImage*)image
{
    return _imageView.image;
}

- (void)setImage:(UIImage *)img
{
    image = img;
    _imageView.image = img;
    [_imageView mx_cancelCurrentImageLoad];
    // 设置缩放比例
    [self adjustFrame];
    //是否允许触摸
    self.userInteractionEnabled = !(img == nil);
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
    self.image = nil;
    [_imageView mx_setImageWithURL:[url absoluteString] placeholderImage:nil completed:^(UIImage *aImage, NSError *error) {
        self.image = aImage;
    }];
}

#pragma mark - static

+ (void)showWithImage:(UIImage*)img
{
    if(mxPhotoView){
        [mxPhotoView reset];
    }
    if(!mxPhotoView){
        mxPhotoView = [[MXPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    mxPhotoView.image = img;
    [mxPhotoView show];
}

+ (void)dismiss
{
    if(mxPhotoView){
        [mxPhotoView remove];
    }
}

#pragma mark - method
- (void)show
{
    if(isShowing){
        return;
    }
    UIWindow *window = [MyCommon normalLevelWindow];
    self.alpha = 0;
    [window addSubview:self];
    //self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished){
        //self.userInteractionEnabled = YES;
    }];
    
    BOOL originStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    self.showStatusBarWhenDismiss = !originStatusBarHidden;
    if(!originStatusBarHidden){
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    }
    isShowing = YES;
    NSLog(@"show");
}

- (void)remove
{
    [self removeWithAnimated:YES];
}

- (void)removeWithAnimated:(BOOL)animated
{
    if(!isShowing){
        return;
    }
    //self.userInteractionEnabled = NO;
    if(showStatusBarWhenDismiss){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    }
    NSTimeInterval interval = 0;
    if(animated){
        interval = 0.2;
    }
    [UIView animateWithDuration:interval delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        //self.userInteractionEnabled = YES;
        [self removeFromSuperview];
    }];
    isShowing = NO;
    NSLog(@"hide");
}

//重置
- (void)reset
{
    if(isShowing){
        [self removeWithAnimated:NO];
    }
    [_imageView mx_cancelCurrentImageLoad];
    _imageView.image = nil;
    [self turnOffZoomAnimated:NO];
}

//恢复初始到缩放值
- (void)turnOffZoomAnimated:(BOOL)yesOrNo
{
    self.contentOffset = CGPointZero;
    if ([self zoomScale] != [self minimumZoomScale]) {
        [self setZoomScale:[self minimumZoomScale] animated:yesOrNo];
    }
}

#pragma mark 调整frame
- (void)adjustFrame
{
    CGSize imgSize = _imageView.image.size;
    
    if(imgSize.width<=0 || imgSize.height<=0){
        return;
    }
    
    //缩放值
    float scaleX = self.frame.size.width/imgSize.width;
    float scaleY = self.frame.size.height/imgSize.height;
    
    self.minimumZoomScale = 1;
    //倍数小的，先到边缘
    if (scaleX > scaleY){
        //Y方向先到边缘
        float imgViewWidth = imgSize.width*scaleY;
        self.maximumZoomScale = self.frame.size.width/imgViewWidth;
        
        if(self.maximumZoomScale<ImageMinScale){
            self.maximumZoomScale = ImageMinScale;
        }
        if(self.maximumZoomScale>ImageMaxScale){
            self.maximumZoomScale = ImageMaxScale;
        }
        //初始位置
        scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
        _imageView.frame = scaleOriginRect;
        //初始缩放值
        if(self.frame.size.width<self.frame.size.height){
            //针对长图的优化
            self.zoomScale = self.maximumZoomScale;
        }else{
            self.zoomScale = self.minimumZoomScale;
        }
        [self setContentOffset:CGPointZero];
    }else {
        //X先到边缘
        float imgViewHeight = imgSize.height*scaleX;
        self.maximumZoomScale = self.frame.size.height/imgViewHeight;
        
        if(self.maximumZoomScale<ImageMinScale){
            self.maximumZoomScale = ImageMinScale;
        }
        if(self.maximumZoomScale>ImageMaxScale){
            self.maximumZoomScale = ImageMaxScale;
        }
        //初始位置
        scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
        _imageView.frame = scaleOriginRect;
        //初始缩放值
        self.zoomScale = self.minimumZoomScale;
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //计算图片缩放时的正确偏移
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = _imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    if (imgFrame.size.width <= boundsSize.width){
        centerPoint.x = boundsSize.width/2;
    }
    
    if (imgFrame.size.height <= boundsSize.height){
        centerPoint.y = boundsSize.height/2;
    }
    
    _imageView.center = centerPoint;
}

#pragma mark - 手势处理
- (void)singleTap:(UITapGestureRecognizer *)tap
{
    [self remove];
    if(_aDelegate && [_aDelegate respondsToSelector:@selector(didTapMXPhotoView:)]){
        [_aDelegate didTapMXPhotoView:self];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

@end