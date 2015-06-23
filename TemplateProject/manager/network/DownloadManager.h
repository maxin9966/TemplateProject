//
//  DownloadManager.h
//  bcj
//
//  Created by antsmen on 15-3-31.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCBlobDownloadManager.h"

//downloader block
typedef void(^DownloadProgressBlock)(CGFloat progress);
typedef void(^DownloadCompletionBlock)(NSString *filePath,NSError *error);

@interface DownloadManager : NSObject

//下载文件
+ (TCBlobDownload *)downloadWithUrl:(NSURL*)url
                           progress:(DownloadProgressBlock)progress
                         completion:(DownloadCompletionBlock)block;

@end
