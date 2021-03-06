//
//  UIImage+Utility.h
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

+ (UIImage*)fastImageWithData:(NSData*)data;
+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path;

//深拷贝（解码）
- (UIImage*)deepCopy;

//重绘
- (UIImage*)aspectFit:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset;
//调整大小
- (UIImage*)resize:(CGSize)size;
//图片等比缩放
- (UIImage*)scaledToWidth:(float)i_width;

//截取
- (UIImage*)crop:(CGRect)rect;
//Create a UIImage from a part of another UIImage
- (UIImage *)getImageInRect:(CGRect)rect;
//居中裁剪出方形
- (UIImage*)centerOfCropToSquare;

- (UIImage*)maskedImage:(UIImage*)maskImage;

//图像处理
//模糊
- (UIImage*)gaussBlur:(CGFloat)blurLevel;       //  {blurLevel | 0 ≤ t ≤ 1}
- (UIImage*)blurredImage:(CGFloat)blurAmount tintColor:(UIColor*)tintColor;//  {blurLevel | 0 ≤ t ≤ 1}
//圆形图片
- (UIImage *)createRoundedWithRadius:(CGFloat)radius;

//修正方向
- (UIImage *)fixOrientation;

@end
