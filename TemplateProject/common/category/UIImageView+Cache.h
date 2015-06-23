//
//  UIImageView+Cache.h
//  Pickup
//
//  Created by MA on 14-9-22.
//  Copyright (c) 2014年 nsxiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUImageManager.h"

@interface UIImageView (Cache)

- (NSString*)mx_imageURL;

- (void)mx_setImageWithURL:(NSString*)urlString;

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder;

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder completed:(ImageDownloaderCompletionBlock)completedBlock;

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder progress:(DownloadProgressBlock)progressBlock completed:(ImageDownloaderCompletionBlock)completedBlock;

- (void)mx_cancelCurrentImageLoad;

@end
