//
//  AFRequest.m
//  FansKit
//
//  Created by MA on 14/12/4.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

+ (instancetype)sharedInstance {
    static HttpRequest* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:ServerBaseURL];
        sharedManager = [[self alloc] initWithBaseURL:baseUrl];
        [sharedManager.operationQueue setMaxConcurrentOperationCount:8];
    });
    return sharedManager;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(self){
        //cookie
        NSArray *cookies =  [MyCommon getDataFromUserDefaultWithKey:kUDLoginCookie];
        for(NSDictionary *cookieProperties in cookies){
            if(cookieProperties.count){
                NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                if(cookie){
                    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    [cookieJar setCookie:cookie];
                }
            }
        }
    }
    return self;
}

+ (AFHTTPRequestOperation *)getWithAPI:(NSString*)api
                            parameters:(NSDictionary*)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"GET %@\n%@",api,params);
    params = [self addIdentity:params];
    AFHTTPRequestOperation *operation = [[self sharedInstance] GET:api parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"RESULT %@\n%@",api,responseObject);
        
        //检测是否被踢下线
        NSError *error = [MyCommon getErrorWithResponse:responseObject];
        if(error && error.code == 21000){
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiRequestNeedLogin object:nil userInfo:nil];
        }
        
        if(success){
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        id url = [error.userInfo objectForKeySafely:@"NSErrorFailingURLKey"];
        NSLog(@"GET error code:%d url:%@ description:%@",(int)error.code,url,error.localizedDescription);
        if(failure && error.code != NSURLErrorCancelled){
            failure(operation,[MyCommon getFailureError:error]);
        }
    }];
    return operation;
}

+ (AFHTTPRequestOperation *)postWithAPI:(NSString*)api
                             parameters:(NSDictionary*)params
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"POST %@\n%@",api,params);
    params = [self addIdentity:params];
    AFHTTPRequestOperation *operation = [[self sharedInstance] POST:api parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"RESULT %@\n%@",api,responseObject);
        
        //检测是否被踢下线
        NSError *error = [MyCommon getErrorWithResponse:responseObject];
        if(error && error.code == 21000){
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiRequestNeedLogin object:nil userInfo:nil];
        }
        
        if(success){
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        id url = [error.userInfo objectForKeySafely:@"NSErrorFailingURLKey"];
        NSLog(@"POST error code:%d url:%@ description:%@",(int)error.code,url,error.localizedDescription);
        if(failure && error.code != NSURLErrorCancelled){
            failure(operation,[MyCommon getFailureError:error]);
        }
    }];
    return operation;
}

+ (NSDictionary*)addIdentity:(NSDictionary*)paramsDict
{
//    NSMutableDictionary *dict = nil;
//    if(!paramsDict){
//        dict = [NSMutableDictionary dictionary];
//    }else{
//        dict = [paramsDict mutableCopy];
//    }
//    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
//    NSString *token = @"";
//    NSString *sign = @"";
//    [dict setObjectSafely:timestamp forKey:@"timestamp"];
//    [dict setObjectSafely:token forKey:@"token"];
//    [dict setObjectSafely:sign forKey:@"sign"];
//    return dict;
    return paramsDict;
}

@end
