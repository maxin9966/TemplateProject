//
//  UIColor+Utility.h
//  FansKit
//
//  Created by MA on 14/12/9.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)

//color序列化
- (NSString*)colorSerializable;

//反色
- (UIColor*)inverseColor;

@end
