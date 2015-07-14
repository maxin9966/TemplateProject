//
//  AFFileLoad.h
//  FansKit
//
//  Created by MA on 14/12/12.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

/**
 
 文件上传
 
 */

#import <Foundation/Foundation.h>

typedef void(^UploadProgressBlock)(CGFloat progress);

@interface UploadManager : AFURLSessionManager

//上传图片
+ (void)uploadImage:(UIImage*)image
           progress:(UploadProgressBlock)progress
         completion:(void (^)(NSString* urlString, NSError* error))completion;

//上传文件
+ (void)uploadFilePath:(NSString*)filePath
              fileName:(NSString*)fileName
              progress:(UploadProgressBlock)progress
            completion:(void (^)(NSString* urlString, NSError* error))completion;

//上传数据
+ (void)uploadData:(NSData*)data
          fileName:(NSString*)fileName
          mimeType:(NSString*)mimeType
          progress:(UploadProgressBlock)progress
        completion:(void (^)(NSString* urlString, NSError* error))completion;

@end
