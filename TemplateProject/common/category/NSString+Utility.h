//
//  NSString+Utility.h
//  FansKit
//
//  Created by MA on 14/12/9.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

//UIColor反序列化
- (UIColor*)colorReverseSerializable;

- (BOOL)isChinese;

- (id)JSONValue;

@end
