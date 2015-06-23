//
//  UIColor+Utility.m
//  FansKit
//
//  Created by MA on 14/12/9.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)

//反色
- (UIColor*)inverseColor
{
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    UIColor *iColor = RGBA((1-components[0])*255, (1-components[1])*255, (1-components[2])*255, components[3]);
    return iColor;
}

@end
