//
//  PULoadFileOperation.h
//  gem
//
//  Created by admin on 15/11/2.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PULoadFileCompletion)(NSData *data, NSError *error);

@interface PULoadFileOperation : NSOperation

@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) PULoadFileCompletion completion;

- (id)initWithFilePath:(NSString *)filePath completion:(PULoadFileCompletion)completion;

@end
