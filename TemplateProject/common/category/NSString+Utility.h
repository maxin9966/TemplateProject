//
//  NSString+Utility.h
//  FansKit
//
//  Created by MA on 14/12/9.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

- (BOOL)isChinese;

- (id)JSONValue;

//忽略nil
- (BOOL)noNilEqualToString:(NSString*)aString;

@end

@interface NSString (Serializable)

//color反序列化
- (UIColor*)colorReverseSerializable;

@end

@interface UIColor (Serializable)

//color序列化
- (NSString*)colorSerializable;

@end
