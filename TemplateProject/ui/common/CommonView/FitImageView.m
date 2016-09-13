//
//  FitImageView.m
//  YanMo
//
//  Created by admin on 15/12/15.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "FitImageView.h"

@implementation FitImageView

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

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
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
    _maxWidth = 100;
    _maxHeight = 100;
    _minWidth = 20;
    _minHeight = 20;
}

- (void)frameToFit
{
    CGSize size = [FitImageView sizeWithImageSizeWidth:_imageSizeWidth imageSizeHeight:_imageSizeHeight maxWidth:_maxWidth maxHeight:_maxHeight minWidth:_minWidth minHeight:_minHeight];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

+ (CGSize)sizeWithImageSizeWidth:(CGFloat)imageSizeWidth imageSizeHeight:(CGFloat)imageSizeHeight maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight minWidth:(CGFloat)minWidth minHeight:(CGFloat)minHeight
{
    if(maxWidth<=0 || maxHeight<=0 || minWidth<=0 || minHeight<=0  || imageSizeWidth<=0 || imageSizeHeight<=0){
        return CGSizeZero;
    }
    CGFloat imageWidth = imageSizeWidth/SCREEN_SCALE;
    CGFloat imageHeight = imageSizeHeight/SCREEN_SCALE;
    CGFloat estimatedWidth = MAX(minWidth, MIN(maxWidth, imageWidth));
    CGFloat estimatedHeight = MAX(minHeight, MIN(maxHeight, imageHeight));
    CGFloat ratio = MIN(estimatedWidth/imageWidth, estimatedHeight/imageHeight);
    return CGSizeMake(imageWidth*ratio, imageHeight*ratio);
}

@end
