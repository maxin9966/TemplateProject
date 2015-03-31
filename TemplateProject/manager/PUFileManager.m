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
- (PUFileDownloadOperation*)downloadFileWithUrl:(NSURL*)url
                                       progress:(DownloaderProgressBlock)progressBlock
                                      completed:(DownloaderCompletionBlock)completedBlock
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
            NSData *data = [cacheManager dataFromDiskForKey:urlString];
            dispatch_async(dispatch_get_main_queue(), ^{
                //判断是否已经取消
                if(!op.isCancelled){
                    if(data){
                        completedBlock(data,nil);
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
                        //持久化
                        [cacheManager store:data forKey:urlString];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completedBlock(data,nil);
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
