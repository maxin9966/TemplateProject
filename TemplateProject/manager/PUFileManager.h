//
//  PUFileManager.h
//  bcj
//
//  Created by antsmen on 15-3-23.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadManager.h"

@interface PUFileManager : NSObject

- (instancetype)initWithNamespace:(NSString*)ns;

//文件下载并缓存
- (TCBlobDownloader*)downloadFileWithUrl:(NSURL*)url
                              progress:(DownloadProgressBlock)progressBlock
                             completed:(DownloadCompletionBlock)completedBlock;

//是否有缓存
- (BOOL)isExistWithUrl:(NSURL*)url;

//获取缓存
- (NSData*)getFileWithUrl:(NSURL*)url;

//清除缓存
- (void)clear;

@end
