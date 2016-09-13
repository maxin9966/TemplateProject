//
//  UIImage+GPUImage.m
//  Artist
//
//  Created by admin on 15/11/17.
//  Copyright © 2015年 antsmen. All rights reserved.
//

//https://github.com/BradLarson/GPUImage

#import "UIImage+GPUImage.h"
#import "GPUImage.h"

@implementation UIImage (GPUImage)

//gpu模糊 需要导入GPUImage框架
- (UIImage*)gpu_Blur
{
    float imgWidth = self.size.width;
    float imgHeight = self.size.height;
    float radius = 25 * sqrt((imgWidth*imgHeight)/(1000*1000));
    if(radius<6.5){
        radius = 6.5;
    }
    return [self gpu_BlurWithRadius:radius];
}

- (UIImage*)gpu_BlurWithRadius:(CGFloat)radius
{
    GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
    filter.blurRadiusInPixels = radius;
    UIImage *blur = [filter imageByFilteringImage:self];
    return blur;
}

- (UIImage*)imageEffect
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self];
    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    
    [stillImageSource processImage];
    
    return [stillImageFilter imageFromCurrentFramebuffer];
}

@end
