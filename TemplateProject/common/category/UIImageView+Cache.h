//
//  UIImageView+Cache.h
//  Pickup
//
//  Created by MA on 14-9-22.
//  Copyright (c) 2014年 nsxiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUImageManager.h"

typedef UIImage*(^MXImageFilterBlock)(UIImage *originImage);
typedef void(^MXImageLoaderCompletionBlock)(UIImage *originImage,UIImage *filteredImage,NSError *error);

@interface UIImageView (Cache)

- (NSString*)mx_imageURL;

/**
 
 显示原图
 
 */
- (void)mx_setImageWithURL:(NSString*)urlString;

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder;

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder completed:(ImageDownloaderCompletionBlock)completedBlock;

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder progress:(DownloadProgressBlock)progressBlock completed:(ImageDownloaderCompletionBlock)completedBlock;

/**
 
 处理图片并显示
 
 */

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder filterBlock:(MXImageFilterBlock)filterBlock;

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder filterBlock:(MXImageFilterBlock)filterBlock completed:(MXImageLoaderCompletionBlock)completedBlock;

- (void)mx_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder progress:(DownloadProgressBlock)progressBlock filterBlock:(MXImageFilterBlock)filterBlock completed:(MXImageLoaderCompletionBlock)completedBlock;

/**
 
 取消
 
 */
- (void)mx_cancelCurrentImageLoad;

@end
