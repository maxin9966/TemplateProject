//
//  Email.h
//  FansKit
//
//  Created by antsmen on 15-1-21.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKPSMTPMessage.h"

@interface Email : NSObject

+ (instancetype)sharedInstance;

- (void)sendToEmail:(NSString*)toEmail subject:(NSString*)subject content:(NSString*)content completion:(BooleanBlock)block;

@end
