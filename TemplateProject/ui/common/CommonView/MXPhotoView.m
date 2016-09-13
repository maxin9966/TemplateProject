//
//  MXZoomImageView.m
//  ASP
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 antsmen. All rights reserved.
//

#import "MXPhotoView.h"
#import <QuartzCore/QuartzCore.h>

#define ImageMaxScale 4         //最大放大倍数
#define ImageMinScale 1.7       //最小放大倍数

static MXPhotoView *singletonZoomImageView = nil;

@interface MXPhotoView ()
<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,assign) BOOL visible;

@end

@implementation MXPhotoView
@synthesize image,url;

- (id)init
{
    self = [super init];
    if(self){
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (void)initialize
{
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
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:singleTap];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (UIImage*)image
{
    return _imageView.image;
}

- (void)setImage:(UIImage *)img
{
    image = img;
    [self reset];
    _imageView.image = img;
    // 设置缩放比例
    [self adjustFrame];
    //是否允许触摸
    self.userInteractionEnabled = !(img == nil);
}

- (void)setUrl:(NSURL *)aUrl
{
    url = aUrl;
    [self reset];
    __weak typeof(self)wSelf = self;
    [_imageView mx_setImageWithURL:[url absoluteString] placeholderImage:nil completed:^(UIImage *aImage, NSError *error) {
        wSelf.image = aImage;
    }];
}

#pragma mark - static
+ (void)showInWindowWithImage:(UIImage*)img
{
    if(!singletonZoomImageView){
        singletonZoomImageView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    if(singletonZoomImageView.visible){
        [singletonZoomImageView hide];
    }
    singletonZoomImageView.image = img;
    [singletonZoomImageView show];
}

+ (void)showInWindowWithUrl:(NSURL*)aUrl
{
    if(!singletonZoomImageView){
        singletonZoomImageView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    if(singletonZoomImageView.visible){
        [singletonZoomImageView hide];
    }
    singletonZoomImageView.url = aUrl;
    [singletonZoomImageView show];
}

+ (void)dismiss
{
    if(singletonZoomImageView.visible){
        [singletonZoomImageView hide];
    }
}

#pragma mark - method
- (void)show
{
    if(_visible){
        return;
    }
    UIWindow *window = [MyCommon normalLevelWindow];
    self.alpha = 0;
    [window addSubview:self];
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        wSelf.alpha = 1;
    } completion:^(BOOL finished){
        
    }];
    _visible = YES;
}

- (void)hide
{
    [self hideWithAnimated:YES];
}

- (void)hideWithAnimated:(BOOL)animated
{
    if(!_visible){
        return;
    }
    __weak typeof(self)wSelf = self;
    if(animated){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            wSelf.alpha = 0;
        } completion:^(BOOL finished){
            [wSelf removeFromSuperview];
        }];
    }else{
        self.alpha = 0;
        [self removeFromSuperview];
    }
    _visible = NO;
}

//重置
- (void)reset
{
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
    
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    
    //缩放值
    float scaleX = selfWidth/imgSize.width;
    float scaleY = selfHeight/imgSize.height;
    
    self.minimumZoomScale = 1;
    //倍数小的，先到边缘
    if (scaleX > scaleY){
        //Y方向先到边缘
        float imgViewWidth = imgSize.width*scaleY;
        self.maximumZoomScale = selfWidth/imgViewWidth;
        
        if(self.maximumZoomScale<ImageMinScale){
            self.maximumZoomScale = ImageMinScale;
        }
        if(self.maximumZoomScale>ImageMaxScale){
            self.maximumZoomScale = ImageMaxScale;
        }
        //初始位置
        CGRect scaleOriginRect = (CGRect){selfWidth/2-imgViewWidth/2,0,imgViewWidth,selfHeight};
        _imageView.frame = scaleOriginRect;
        //初始缩放值
        if(selfWidth<selfHeight && (imgSize.height/imgSize.width)/(selfHeight/selfWidth)>ImageMinScale){
            //针对长图的优化
            self.zoomScale = self.maximumZoomScale;
        }else{
            self.zoomScale = self.minimumZoomScale;
        }
        [self setContentOffset:CGPointZero];
    }else {
        //X先到边缘
        float imgViewHeight = imgSize.height*scaleX;
        self.maximumZoomScale = selfHeight/imgViewHeight;
        
        if(self.maximumZoomScale<ImageMinScale){
            self.maximumZoomScale = ImageMinScale;
        }
        if(self.maximumZoomScale>ImageMaxScale){
            self.maximumZoomScale = ImageMaxScale;
        }
        //初始位置
        CGRect scaleOriginRect = (CGRect){0,selfHeight/2-imgViewHeight/2,selfWidth,imgViewHeight};
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


#pragma mark - Tap Gesture
- (void)singleTap:(UITapGestureRecognizer *)tap
{
    [self hide];
    if(_singleTap){
        _singleTap();
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
