//
//  PUImageManager.m
//  TemplateProject
//
//  Created by antsmen on 15-3-18.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "PUImageManager.h"
#import "PULoadImageOperation.h"

@interface PUImageManager()
{
    NSOperationQueue *queue;
}

@end

@implementation PUImageManager
@synthesize cacheManager;

- (instancetype)initWithNamespace:(NSString*)ns
{
    if(!ns.length){
        return nil;
    }
    self = [super init];
    if(self){
        cacheManager = [[PUCache alloc] initWithNamespace:ns];
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 3;
    }
    return self;
}

//读取本地图片
- (NSOperation*)loadImageWithFilePath:(NSString*)filePath
                            completed:(ImageDownloaderCompletionBlock)completedBlock
{
    PULoadImageOperation *op = nil;
    BOOL isExist = [cacheManager memExistsWithKey:filePath];
    __weak typeof(self)wSelf = self;
    if(isExist){
        UIImage *image = [cacheManager imageFromMemoryCacheForKey:filePath];
        if(completedBlock){
            completedBlock(image,nil);
        }
    }else{
        op = [[PULoadImageOperation alloc] initWithFilePath:filePath completion:^(UIImage *image, NSError *error) {
            if(completedBlock){
                completedBlock(image,error);
            }
            [wSelf.cacheManager storeImage:image forKey:filePath];
        }];
        [queue addOperation:op];
    }
    return op;
}

//图片下载并缓存
- (NSOperation*)downloadImageWithUrl:(NSURL*)url
                            progress:(DownloadProgressBlock)progressBlock
                           completed:(ImageDownloaderCompletionBlock)completedBlock
{
    if(!url){
        completedBlock(nil,[NSError new]);
        return nil;
    }
    
    TCBlobDownloader* op = [TCBlobDownloader new];
    
    NSString *urlString = [url absoluteString];
    BOOL isExist = [cacheManager existsWithKey:urlString];
    __weak typeof(self)wSelf = self;
    if(isExist){
        //已经存在
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [wSelf.cacheManager imageForKey:urlString];
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
        op = [DownloadManager downloadWithUrl:url progress:progressBlock completion:^(NSString *filePath, NSError *error) {
            if(!op.isCancelled){
                if(!error && filePath){
                    //成功
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        //持久化
                        [wSelf.cacheManager moveFile:filePath forKey:urlString];
                        UIImage *image = [wSelf.cacheManager imageForKey:urlString];
                        //test
                        if(!error && !image){
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(!op.isCancelled){
                                completedBlock(image,nil);
                            }
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
