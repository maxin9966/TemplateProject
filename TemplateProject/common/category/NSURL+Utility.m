//
//  NSURL+Utility.m
//  gem
//
//  Created by admin on 15/11/2.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "NSURL+Utility.h"

@implementation NSURL (Utility)

- (NSString*)string
{
    if([self isFileURL]){
        return [self path];
    }else{
        return [self absoluteString];
    }
}

@end
