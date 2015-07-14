//
//  AFFileLoad.m
//  FansKit
//
//  Created by MA on 14/12/12.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "UploadManager.h"

@implementation UploadManager

+ (id)sharedInstance {
    static AFURLSessionManager* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [sharedManager.operationQueue setMaxConcurrentOperationCount:4];
    });
    return sharedManager;
}

+ (void)uploadImage:(UIImage*)image
           progress:(UploadProgressBlock)progressBlock
         completion:(void (^)(NSString* urlString, NSError* error))completion
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);

    [self uploadData:imageData fileName:@"image.jpg" mimeType:@"image/png" progress:progressBlock completion:completion];
}

+ (void)uploadFilePath:(NSString*)filePath
              fileName:(NSString*)fileName
              progress:(UploadProgressBlock)progressBlock
            completion:(void (^)(NSString* urlString, NSError* error))completion;
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    [self uploadData:data fileName:fileName mimeType:@"application/octet-stream" progress:progressBlock completion:completion];
}

+ (void)uploadData:(NSData*)data
          fileName:(NSString*)fileName
          mimeType:(NSString*)mimeType
          progress:(UploadProgressBlock)progressBlock
        completion:(void (^)(NSString* urlString, NSError* error))completion;
{
    [self uploadData:data fileName:fileName mimeType:mimeType progress:progressBlock completion:completion];
}

- (void)uploadData:(NSData*)data
          fileName:(NSString*)fileName
          mimeType:(NSString*)mimeType
          progress:(UploadProgressBlock)progressBlock
        completion:(void (^)(NSString* urlString, NSError* error))completion;
{
    NSString *path = @"file/updateFiles.action";
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[ServerBaseURL stringByAppendingString:path] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"fileData" fileName:fileName mimeType:mimeType];
    } error:nil];
    
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [[UploadManager sharedInstance] uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if(completion){
            if (error) {
                NSLog(@"___Upload Error:%@",error.description);
                completion(nil,error);
            } else {
                NSLog(@"___Upload Success:%@",responseObject);
                NSString *urlString = [[responseObject objectForKey:kResponseData] firstObject];
                completion(urlString,nil);
            }
        }
    }];
    
    [RACObserve(progress,fractionCompleted) subscribeNext:^(NSNumber *number) {
        if(progressBlock){
            progressBlock([number doubleValue]);
        }
    }];
    
    [uploadTask resume];
}

@end
