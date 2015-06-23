//
//  PUFileManager.m
//  bcj
//
//  Created by antsmen on 15-3-23.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "PUFileManager.h"
#import "PUCache.h"

@interface PUFileManager()
{
    //缓存管理器
    PUCache *cacheManager;
}

@end

@implementation PUFileManager

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

//下载
- (TCBlobDownload*)downloadFileWithUrl:(NSURL*)url
                              progress:(DownloadProgressBlock)progressBlock
                             completed:(DownloadCompletionBlock)completedBlock;
{
    if(!url){
        completedBlock(nil,[NSError new]);
        return nil;
    }
    
    TCBlobDownload *op = nil;
    
    NSString *urlString = [url absoluteString];
    BOOL isExist = [cacheManager existsWithKey:urlString];
    if(isExist){
        //已经存在
        NSString *cachePath = [cacheManager cachePathForKey:urlString];
        if(cachePath.length){
            completedBlock(cachePath,nil);
        }
    }else{
        //下载
        op = [DownloadManager downloadWithUrl:url progress:progressBlock completion:^(NSString *filePath, NSError *error) {
            if(!op.isCancelled){
                if(!error && filePath){
                    //成功
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        //持久化
                        [cacheManager moveFile:filePath forKey:urlString];
                        NSString *cachePath = [cacheManager cachePathForKey:urlString];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(!op.isCancelled){
                                completedBlock(cachePath,nil);
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

//获取缓存
- (NSData*)getFileWithUrl:(NSURL*)url
{
    NSString *urlString = [url absoluteString];
    return [cacheManager dataFromDiskForKey:urlString];
}

//是否有缓存
- (BOOL)isExistWithUrl:(NSURL*)url
{
    NSString *urlString = [url absoluteString];
    return [cacheManager existsWithKey:urlString];
}

//清除缓存
- (void)clear
{
    [cacheManager clearMemory];
    [cacheManager clearDisk];
}

@end
