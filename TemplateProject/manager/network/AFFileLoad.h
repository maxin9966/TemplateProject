//
//  AFFileLoad.h
//  FansKit
//
//  Created by MA on 14/12/12.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

/**
 
 文件上传下载
 
 */

#import <Foundation/Foundation.h>
#import "AFURLSessionManager.h"

typedef void(^DownloadProgressBlock)(CGFloat progress);
typedef void(^DownloadCompletionBlock)(NSString *filePath,NSError *error);

@interface AFFileLoad : AFURLSessionManager

//上传图片
+ (NSURLSessionUploadTask*)uploadImage:(UIImage*)image completion:(void (^)(NSString* urlString, NSError* error))completion;

//上传文件
+ (NSURLSessionUploadTask*)uploadFilePath:(NSString*)filePath fileName:(NSString*)fileName completion:(void (^)(NSString* urlString, NSError* error))completion;

//下载
+ (NSURLSessionDownloadTask*)downloadFileWithURL:(NSURL*)url progress:(DownloadProgressBlock)progressBlock completion:(DownloadCompletionBlock)completionHandler;

@end
