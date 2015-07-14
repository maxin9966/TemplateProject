//
//  AFFileLoad.m
//  FansKit
//
//  Created by MA on 14/12/12.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "AFFileLoad.h"

@implementation AFFileLoad

+ (id)sharedInstance {
    static AFURLSessionManager* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [sharedManager.operationQueue setMaxConcurrentOperationCount:5];
    });
    return sharedManager;
}

+ (NSURLSessionUploadTask*)uploadImage:(UIImage*)image completion:(void (^)(NSString* urlString, NSError* error))completion
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);

    return [self uploadData:imageData fileName:@"image.jpg" mimeType:@"image/png" completion:completion];
}

+ (NSURLSessionUploadTask*)uploadFilePath:(NSString*)filePath fileName:(NSString*)fileName completion:(void (^)(NSString* urlString, NSError* error))completion
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    return [self uploadData:data fileName:fileName mimeType:@"application/octet-stream" completion:completion];
}

+ (NSURLSessionUploadTask*)uploadData:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)mimeType completion:(void (^)(NSString* urlString, NSError* error))completion
{
    //NSString *path = @"file/updateFiles.action";
    //NSString *server = [ServerBaseURL stringByAppendingString:path];
    NSString *server = @"http://112.124.47.195/updateFile/update.action";
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:server parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"fileData" fileName:fileName mimeType:mimeType];
    } error:nil];
    
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [[AFFileLoad sharedInstance] uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if(completion){
            //cancel不回调
            if(error.code != NSURLErrorCancelled){
                if (error) {
                    NSLog(@"___upload error:%@",error.description);
                    completion(nil,error);
                } else {
                    NSLog(@"___upload success:%@",responseObject);
                    NSString *urlString = [[responseObject objectForKey:kResponseData] firstObject];
                    completion(urlString,nil);
                }
            }
        }
    }];
    
    [uploadTask resume];
    return uploadTask;
}

//下载
+ (NSURLSessionDownloadTask*)downloadFileWithURL:(NSURL*)url progress:(DownloadProgressBlock)progressBlock completion:(DownloadCompletionBlock)completionHandler
{
    if(!url){
        if(completionHandler){
            completionHandler(nil,[MyCommon getFailureError:nil]);
        }
        return nil;
    }
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    NSProgress *progress = nil;
    
    NSURLSessionDownloadTask *task =[[AFFileLoad sharedInstance] downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return targetPath;//[NSURL URLWithString:[[MyCommon imageManager].cacheManager cachePathForKey:[MyCommon createUUID]]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if(completionHandler){
            completionHandler([filePath absoluteString],error);
        }
    }];
    
//    NSURLSessionDownloadTask *task =[[AFFileLoad sharedInstance] downloadTaskWithRequest:request progress:&progress destination:nil completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        if(completionHandler){
//            completionHandler([filePath absoluteString],error);
//        }
//    }];
    
    [task resume];
    return task;
}

@end
