//
//  UIImage+GPUImage.h
//  Artist
//
//  Created by admin on 15/11/17.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GPUImage)

- (UIImage*)gpu_Blur;

- (UIImage*)gpu_BlurWithRadius:(CGFloat)radius;

- (UIImage*)imageEffect;

@end
