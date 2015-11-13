//
//  MXURLSessionDownloadTask.h
//  LaneTrip
//
//  Created by antsmen on 15-4-30.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXURLSessionDownloadTask : NSObject

@property (nonatomic,strong) NSURLSessionDownloadTask *task;
@property (nonatomic,assign) BOOL isCancelled;

- (void)cancel;

@end
