//
//  PULoadImageOperation.h
//  gem
//
//  Created by admin on 15/11/2.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "PULoadFileOperation.h"

typedef void(^PULoadImageCompletion)(UIImage *image, NSError *error);

@interface PULoadImageOperation : NSOperation

@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) PULoadImageCompletion completion;

- (id)initWithFilePath:(NSString *)filePath completion:(PULoadImageCompletion)completion;

@end
