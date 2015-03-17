//
//  NSDictionary+Utility.h
//  FansKit
//
//  Created by MA on 14/12/12.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utility)

//返回非NULL
- (id)objectForKeySafely:(id <NSCopying>)aKey;

//如果是NULL则返回@""
- (NSString*)stringForKeyNonNil:(id <NSCopying>)aKey;

@end

@interface NSMutableDictionary (Utility)

- (void)setObjectSafely:(id)obj forKey:(id <NSCopying>)aKey;

@end
