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

/**
 
 原图
 
 */

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
    [self mx_setImageWithURL:urlString placeholderImage:placeholder progress:progressBlock filterBlock:nil completed:^(UIImage *originImage, UIImage *filteredImage, NSError *error) {
        if(completedBlock){
            completedBlock(originImage,error);
        }
    }];
    
//    [self mx_cancelCurrentImageLoad];
//    
//    self.image = placeholder;
//    
//    if([urlString isKindOfClass:[NSURL class]]){
//        NSURL *url = (NSURL*)urlString;
//        urlString = [url string];
//    }
//    
//    if(!urlString.length){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(completedBlock){
//                completedBlock(nil,[NSError new]);
//            }
//        });
//        return;
//    }
//    
//    objc_setAssociatedObject(self, &imageUrlKey, urlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
//    __weak UIImageView *wself = self;
//    NSOperation *operation = nil;
//    if([urlString isAbsolutePath]){
//        //读取本地图片
//        operation = [[MyCommon imageManager] loadImageWithFilePath:urlString completed:^(UIImage *image, NSError *error) {
//            [wself doneWithImage:image error:error completed:completedBlock];
//        }];
//    }else{
//        //下载并缓存图片
//        operation = [[MyCommon imageManager] downloadImageWithUrl:[NSURL URLWithString:urlString] progress:^(CGFloat progress) {
//            if(progressBlock){
//                progressBlock(progress);
//            }
//        } completed:^(UIImage *image, NSError *error) {
//            [wself doneWithImage:image error:error completed:completedBlock];
//        }];
//    }
//    objc_setAssociatedObject(self, &imageOperationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 
 图片处理
 
 */
- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder filterBlock:(MXImageFilterBlock)filterBlock
{
    [self mx_setImageWithURL:urlString placeholderImage:placeholder filterBlock:filterBlock completed:nil];
}

- (void)mx_setImageWithURL:(NSString*)urlString placeholderImage:(UIImage *)placeholder filterBlock:(MXImageFilterBlock)filterBlock completed:(MXImageLoaderCompletionBlock)completedBlock
{
    [self mx_setImageWithURL:urlString placeholderImage:placeholder progress:nil filterBlock:filterBlock completed:completedBlock];
}

- (void)mx_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder progress:(DownloadProgressBlock)progressBlock filterBlock:(MXImageFilterBlock)filterBlock completed:(MXImageLoaderCompletionBlock)completedBlock
{
    [self mx_cancelCurrentImageLoad];
    
    self.image = placeholder;
    
    if([urlString isKindOfClass:[NSURL class]]){
        NSURL *url = (NSURL*)urlString;
        urlString = [url string];
    }
    
    if(!urlString.length){
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completedBlock){
                completedBlock(nil,nil,[NSError new]);
            }
        });
        return;
    }
    
    objc_setAssociatedObject(self, &imageUrlKey, urlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    __weak UIImageView *wself = self;
    NSOperation *operation = nil;
    if([urlString isAbsolutePath]){
        //读取本地图片
        operation = [[MyCommon imageManager] loadImageWithFilePath:urlString completed:^(UIImage *image, NSError *error) {
            [wself doneWithImage:image error:error operation:operation filterBlock:filterBlock completed:completedBlock];
        }];
    }else{
        //下载并缓存图片
        operation = [[MyCommon imageManager] downloadImageWithUrl:[NSURL URLWithString:urlString] progress:^(CGFloat progress) {
            if(progressBlock){
                progressBlock(progress);
            }
        } completed:^(UIImage *image, NSError *error) {
            [wself doneWithImage:image error:error operation:operation filterBlock:filterBlock completed:completedBlock];
        }];
    }
    objc_setAssociatedObject(self, &imageOperationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)doneWithImage:(UIImage*)image error:(NSError*)error operation:(NSOperation*)op filterBlock:(MXImageFilterBlock)filterBlock completed:(MXImageLoaderCompletionBlock)completedBlock
{
    __weak typeof(self)wSelf = self;
    [IDNTask putTask:^id{
        UIImage *filteredImage = nil;
        if(filterBlock){
            filteredImage = filterBlock(image);
        }
        return filteredImage;
    } finished:^(UIImage *filteredImage) {
        if(!op.isCancelled){
            if(!error){
                if (!wSelf) return;
                if(filteredImage){
                    [wSelf setImage:filteredImage];
                }else{
                    [wSelf setImage:image];
                }
                [wSelf setNeedsLayout];
            }
            if (completedBlock) {
                completedBlock(image, filteredImage, error);
            }
        }
        objc_setAssociatedObject(wSelf, &imageOperationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } cancelled:nil];
}

//- (void)doneWithImage:(UIImage*)image error:(NSError*)error completed:(ImageDownloaderCompletionBlock)completedBlock
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if(!error){
//            if (!self) return;
//            [self setImage:image];
//            [self setNeedsLayout];
//        }
//        if (completedBlock) {
//            completedBlock(image, error);
//        }
//        objc_setAssociatedObject(self, &imageOperationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    });
//}

- (void)mx_cancelCurrentImageLoad
{
    NSOperation *op = objc_getAssociatedObject(self, &imageOperationKey);
    if(op && !op.isCancelled){
        [op cancel];
    }
//    objc_removeAssociatedObjects(self);
    objc_setAssociatedObject(self, &imageUrlKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &imageOperationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
