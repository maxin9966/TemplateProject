//
//  NSString+Utility.h
//  FansKit
//
//  Created by MA on 14/12/9.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MXStringPosition) {
    MXStringPositionFront,
    MXStringPositionMiddle,
    MXStringPositionEnding,
};

@interface NSString (Utility)

- (BOOL)isChinese;

- (id)JSONValue;

//忽略nil
- (BOOL)noNilEqualToString:(NSString*)aString;

//隐藏某段 用字符替代
- (NSString*)hideInPosition:(MXStringPosition)positionType number:(NSUInteger)number replaceChar:(unichar)aChar;

- (NSURL*)url;

@end

@interface NSString (Serializable)

//color反序列化
- (UIColor*)colorReverseSerializable;

@end

@interface UIColor (Serializable)

//color序列化
- (NSString*)colorSerializable;

@end
