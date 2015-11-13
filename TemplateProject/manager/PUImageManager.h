//
//  PUImageManager.h
//  TemplateProject
//
//  Created by antsmen on 15-3-18.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadManager.h"
#import "PUCache.h"

/**
 
 图片管理
 
 */

typedef void(^ImageDownloaderCompletionBlock)(UIImage *image,NSError *error);

@interface PUImageManager : NSObject

@property (nonatomic,strong) PUCache *cacheManager;

- (instancetype)initWithNamespace:(NSString*)ns;

//读取本地图片
- (NSOperation*)loadImageWithFilePath:(NSString*)filePath
                            completed:(ImageDownloaderCompletionBlock)completedBlock;

//图片下载并缓存
- (NSOperation*)downloadImageWithUrl:(NSURL*)url
                               progress:(DownloadProgressBlock)progressBlock
                              completed:(ImageDownloaderCompletionBlock)completedBlock;

//是否有缓存
- (BOOL)isExistWithUrl:(NSURL*)url;

//获取缓存
- (UIImage*)getCacheWithUrl:(NSURL*)url;

//清除缓存
- (void)clear;

@end
