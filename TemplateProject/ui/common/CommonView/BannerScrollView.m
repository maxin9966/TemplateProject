//
//  BannerScrollView.m
//  TemplateProject
//
//  Created by admin on 15/7/28.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "BannerScrollView.h"

@interface BannerScrollView()
<UIScrollViewDelegate>
{
    NSTimer *timer;
    
    UIScrollView *scrollView;
    NSDate *startDate;
    NSDate *preUpdateDate;
    
    NSMutableArray *displayArray;
    NSMutableArray *recyleArray;
    
    NSInteger index;
    
    BOOL isRunning;
}

@end

@implementation BannerScrollView

- (void)clear
{
    for(UIImageView *imgView in displayArray){
        [imgView removeFromSuperview];
    }
    [displayArray removeAllObjects];
    [recyleArray removeAllObjects];
    index = 0;
}

- (void)setImages:(NSArray *)images
{
    if([_images isEqualToArray:images]){
        return;
    }
    _images = images;
    [self stop];
    [self clear];
    [self update];
}

- (void)setSpeed:(CGFloat)speed
{
    if(speed<0){
        speed=0;
    }
    if(speed>1){
        speed = 1;
    }
    _speed = speed;
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
    displayArray = [NSMutableArray array];
    recyleArray = [NSMutableArray array];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = NO;
    [self addSubview:scrollView];
    
    _speed = 0.5;
    
    [self clear];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    scrollView.frame = self.bounds;
    
    if(isRunning){
        [self clear];
        [self update];
    }
}

- (void)scroll
{
    NSDate *nowDate = [NSDate date];
    CGFloat deltaInterval = [nowDate timeIntervalSinceDate:preUpdateDate];
    CGFloat deltaX = deltaInterval*_speed*1000;
    
    if(deltaX && deltaX>=_minOffset){
        if(_minOffset){
            deltaX = (int)(deltaX/_minOffset) * _minOffset;
        }
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x+deltaX, 0)];
        preUpdateDate = nowDate;
    }
}

#pragma mark - public method
- (void)start
{
    if(isRunning || !_images.count){
        return;
    }
    NSDate *nowDate = [NSDate date];
    startDate = nowDate;
    preUpdateDate = startDate;
    //[self update];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    isRunning = YES;
}

- (void)stop
{
    if(!isRunning){
        return;
    }
    [timer invalidate];
    [scrollView scrollToLeftAnimated:NO];
    startDate = nil;
    preUpdateDate = nil;
    isRunning = NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    [self update];
}

#pragma mark - method

- (void)update
{
    CGFloat sizeWidth = scrollView.frame.size.width;
    CGFloat sizeHeight = scrollView.frame.size.height;
    if(!_images.count || sizeWidth==0 || sizeHeight==0){
        return;
    }
    CGFloat offsetX = scrollView.contentOffset.x;
    
    CGFloat leftX = offsetX;
    CGFloat rightX = leftX+sizeWidth*2;
    
    //remove
    for(NSInteger i=0;i<displayArray.count;i++){
        UIImageView *imageView = [displayArray objectAtIndex:i];
        if(imageView.rightX<leftX || imageView.leftX>rightX){
            [displayArray removeObjectAtIndex:i];
            [self saveImageView:imageView];
            i--;
        }
    }
    //add
    UIImageView *lastImageView = [displayArray lastObject];
    while (!lastImageView || lastImageView.rightX<rightX) {
        UIImageView *imageView = [self getRecyclableImageView];
        if(!imageView){
            imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        [displayArray addObject:imageView];
        UIImage *image = [_images objectAtIndex:index%_images.count];
        CGSize imageSize = image.size;
        imageView.frame = CGRectMake(lastImageView.rightX, 0, sizeHeight*(imageSize.width/imageSize.height), sizeHeight);
        imageView.image = image;
        [scrollView addSubview:imageView];
        index++;
        lastImageView = [displayArray lastObject];
    }
}

- (UIImageView*)getRecyclableImageView
{
    UIImageView *imageView = [recyleArray lastObject];
    [recyleArray removeObject:imageView];
    return imageView;
}

- (void)saveImageView:(UIImageView*)imageView
{
    if(!imageView){
        return;
    }
    if(!recyleArray){
        recyleArray = [NSMutableArray array];
    }
    [recyleArray addObject:imageView];
}

@end
