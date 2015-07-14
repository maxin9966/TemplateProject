//
//  UIImageView+Cache.m
//  Pickup
//
//  Created by MA on 14-9-22.
//  Copyright (c) 2014年 nsxiu. All rights reserved.
//

#import "UIImageView+Cache.h"
#import "objc/runtime.h"

static char imageUrlKey;
static char imageOperationKey;

@implementation UIImageView (Cache)

- (NSString*)mx_imageURL
{
    return objc_getAssociatedObject(self, &imageUrlKey);
}

- (void)mx_setImageWithURL:(NSString*)urlString
{
    [self mx_setImageWithURL:urlString placeholderImage:nil];
}

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder
{
    [self mx_setImageWithURL:urlString placeholderImage:placeholder completed:nil];
}

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder completed:(ImageDownloaderCompletionBlock)completedBlock
{
    [self mx_setImageWithURL:urlString placeholderImage:placeholder progress:nil completed:completedBlock];
}

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder progress:(DownloadProgressBlock)progressBlock completed:(ImageDownloaderCompletionBlock)completedBlock
{
    [self mx_cancelCurrentImageLoad];
    
    self.image = placeholder;
    
    if(!urlString.length){
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completedBlock){
                completedBlock(nil,[NSError new]);
            }
        });
        return;
    }
    
    if([urlString isKindOfClass:[NSURL class]]){
        NSURL *url = (NSURL*)urlString;
        urlString = [url absoluteString];
    }
    
    objc_setAssociatedObject(self, &imageUrlKey, urlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    __weak UIImageView *wself = self;
    TCBlobDownloader *operation = [[MyCommon imageManager] downloadImageWithUrl:[NSURL URLWithString:urlString] progress:^(CGFloat progress) {
        if(progressBlock){
            progressBlock(progress);
        }
    } completed:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(image && !error){
                if (!wself) return;
                [self setImage:image];
                [self setNeedsLayout];
            }
            if (completedBlock) {
                completedBlock(image, error);
            }
            objc_setAssociatedObject(self, &imageOperationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        });
    }];
    objc_setAssociatedObject(self, &imageOperationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mx_cancelCurrentImageLoad
{
    TCBlobDownloader *op = objc_getAssociatedObject(self, &imageOperationKey);
    if(op && !op.isCancelled){
        [op cancel];
    }
    objc_removeAssociatedObjects(self);
}

@end
