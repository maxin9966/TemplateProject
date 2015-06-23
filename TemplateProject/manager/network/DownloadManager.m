//
//  DownloadManager.m
//  bcj
//
//  Created by antsmen on 15-3-31.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "DownloadManager.h"

static TCBlobDownloadManager *downloadManager = nil;

@implementation DownloadManager

//下载文件
+ (TCBlobDownload *)downloadWithUrl:(NSURL*)url
                           progress:(DownloadProgressBlock)progress
                         completion:(DownloadCompletionBlock)block
{
    if(!downloadManager){
        downloadManager = [[TCBlobDownloadManager alloc] init];
        [downloadManager setMaxConcurrentDownloads:4];
    }
    TCBlobDownload *op = [downloadManager startDownloadWithURL:url customPath:nil firstResponse:nil progress:^(float receivedLength, float totalLength) {
        if(progress){
            progress(receivedLength/totalLength);
        }
    } error:^(NSError *error) {
        if(block){
            block(nil,error);
        }
    } complete:^(BOOL downloadFinished, NSString *pathToFile) {
        if(downloadFinished && block){
            block(pathToFile,nil);
        }
    }];
    return op;
}

@end
