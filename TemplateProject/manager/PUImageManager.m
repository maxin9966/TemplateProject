//
//  PUImageManager.m
//  TemplateProject
//
//  Created by antsmen on 15-3-18.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "PUImageManager.h"
#import "PUCache.h"

@interface PUImageManager()
{
    //缓存管理器
    PUCache *cacheManager;
}

@end

@implementation PUImageManager

- (instancetype)initWithNamespace:(NSString*)ns
{
    if(!ns.length){
        return nil;
    }
    self = [super init];
    if(self){
        cacheManager = [[PUCache alloc] initWithNamespace:ns];
    }
    return self;
}

//图片下载并缓存
- (PUFileDownloadOperation*)downloadImageWithUrl:(NSURL*)url
                                        progress:(DownloaderProgressBlock)progressBlock
                                       completed:(ImageDownloaderCompletionBlock)completedBlock
{
    if(!url){
        completedBlock(nil,[NSError new]);
        return nil;
    }
    
    PUFileDownloadOperation* op = [PUFileDownloadOperation new];
    
    NSString *urlString = [url absoluteString];
    BOOL isExist = [cacheManager existsWithKey:urlString];
    if(isExist){
        //已经存在
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [cacheManager imageForKey:urlString];
            if(image){
                //解析图片 避免卡顿
                [image resizedImageWithSize:CGSizeMake(1, 1)];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //判断是否已经取消
                if(!op.isCancelled){
                    if(image){
                        completedBlock(image,nil);
                    }else{
                        completedBlock(nil,[NSError new]);
                    }
                }
            });
        });
    }else{
        //下载
        op.httpOperation = [FileLoad downloadWithUrl:url progress:progressBlock completion:^(NSData *data, NSError *error) {
            if(!op.isCancelled){
                if(!error && data){
                    //成功
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        UIImage *image = [UIImage imageWithData:data];
                        //解析图片 避免卡顿
                        [image resizedImageWithSize:CGSizeMake(1, 1)];
                        //持久化
                        [cacheManager storeImage:image forKey:urlString];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completedBlock(image,nil);
                        });
                    });
                }else{
                    //失败
                    completedBlock(nil,error);
                }
            }
        }];
    }
    return op;
}

//是否有缓存
- (BOOL)isExistWithUrl:(NSURL*)url
{
    NSString *urlString = [url absoluteString];
    return [cacheManager existsWithKey:urlString];
}

//获取缓存
- (UIImage*)getCacheWithUrl:(NSURL*)url
{
    NSString *urlString = [url absoluteString];
    return [cacheManager imageForKey:urlString];
}

//清除缓存
- (void)clear
{
    [cacheManager clearMemory];
    [cacheManager clearDisk];
}

@end
